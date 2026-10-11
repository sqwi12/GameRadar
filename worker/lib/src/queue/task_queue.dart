import 'dart:convert';

import 'package:meta/meta.dart';

import '../clock.dart';

/// Полоса очереди. Каждая полоса обрабатывается своим циклом,
/// поэтому лимит одного хоста Steam не тормозит задачи другого.
enum Lane {
  /// store.steampowered.com: цены, описания, отзывы.
  store,

  /// api.steampowered.com: онлайн, список приложений, чарт.
  api,

  /// CDN Steam (*.steamstatic.com): обложки игр.
  cdn,

  /// Без запросов к Steam: отложенные уведомления.
  local,

  /// api.isthereanydeal.com: исторические минимумы цен.
  itad,
}

/// Виды задач.
abstract final class TaskKind {
  static const prices = 'prices';
  static const details = 'details';
  static const reviews = 'reviews';
  static const players = 'players';
  static const appList = 'app_list';
  static const topChart = 'top_chart';
  static const notify = 'notify';
  static const image = 'image';
  static const wishlist = 'wishlist';
  static const storeLows = 'store_lows';
}

/// Задача очереди. [id] детерминирован (например, `players:730`), поэтому
/// одна и та же работа не попадает в очередь дважды.
@immutable
final class QueueTask {
  const QueueTask({
    required this.id,
    required this.kind,
    required this.lane,
    required this.priority,
    this.payload = const {},
    this.attempts = 0,
  });

  factory QueueTask.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, Object?>;
    return QueueTask(
      id: map['id']! as String,
      kind: map['kind']! as String,
      lane: Lane.values.byName(map['lane']! as String),
      priority: map['priority']! as int,
      payload: (map['payload'] as Map<String, Object?>?) ?? const {},
      attempts: (map['attempts'] as int?) ?? 0,
    );
  }

  final String id;
  final String kind;
  final Lane lane;

  /// Чем меньше, тем раньше задача будет выполнена. Это крайний срок
  /// в миллисекундах эпохи с поправкой на число подписчиков.
  final int priority;
  final Map<String, Object?> payload;

  /// Сколько раз задача уже завершилась временной ошибкой.
  final int attempts;

  QueueTask copyWith({int? attempts}) => QueueTask(
    id: id,
    kind: kind,
    lane: lane,
    priority: priority,
    payload: payload,
    attempts: attempts ?? this.attempts,
  );

  String toJson() => jsonEncode({
    'id': id,
    'kind': kind,
    'lane': lane.name,
    'priority': priority,
    'payload': payload,
    'attempts': attempts,
  });

  @override
  String toString() => 'QueueTask($id, attempts: $attempts)';
}

/// Очередь задач worker.
///
/// Семантика (одинакова для памяти и Redis):
/// - задача с уже существующим id не добавляется повторно (пока не завершена);
/// - [dequeue] выдаёт готовую задачу с наименьшим приоритетом и берёт её
///   «в аренду»: если worker упал и не вызвал [complete]/[retry], после
///   истечения аренды задача вернётся в очередь;
/// - [retry] откладывает задачу на [delay].
abstract interface class TaskQueue {
  /// Возвращает false, если задача с таким id уже в очереди.
  Future<bool> enqueue(QueueTask task, {Duration delay = Duration.zero});

  Future<QueueTask?> dequeue(
    Lane lane, {
    Duration lease = const Duration(minutes: 10),
  });

  Future<void> complete(QueueTask task);

  Future<void> retry(QueueTask task, Duration delay);

  /// Сколько задач вида [kind] сейчас в очереди (включая отложенные и в работе).
  Future<int> countKind(String kind);

  /// Сколько задач ждёт выполнения в полосе (готовые + отложенные).
  Future<int> backlog(Lane lane);
}

/// Очередь в памяти: для тестов и локальной отладки.
final class InMemoryTaskQueue implements TaskQueue {
  InMemoryTaskQueue(this.clock);

  final Clock clock;

  final _tasks = <String, QueueTask>{};

  /// id → момент, раньше которого задачу не выдавать (отложенные и аренда).
  final _notBefore = <String, DateTime>{};
  final _leased = <String>{};

  @visibleForTesting
  Map<String, QueueTask> get tasks => Map.unmodifiable(_tasks);

  @visibleForTesting
  DateTime? notBefore(String id) => _notBefore[id];

  @override
  Future<bool> enqueue(QueueTask task, {Duration delay = Duration.zero}) async {
    if (_tasks.containsKey(task.id)) return false;
    _tasks[task.id] = task;
    if (delay > Duration.zero) _notBefore[task.id] = clock.now().add(delay);
    return true;
  }

  @override
  Future<QueueTask?> dequeue(
    Lane lane, {
    Duration lease = const Duration(minutes: 10),
  }) async {
    final now = clock.now();
    QueueTask? best;
    for (final task in _tasks.values) {
      if (task.lane != lane) continue;
      final notBefore = _notBefore[task.id];
      if (notBefore != null && notBefore.isAfter(now)) continue;
      if (best == null || task.priority < best.priority) best = task;
    }
    if (best != null) {
      _leased.add(best.id);
      _notBefore[best.id] = now.add(lease);
    }
    return best;
  }

  @override
  Future<void> complete(QueueTask task) async {
    _tasks.remove(task.id);
    _notBefore.remove(task.id);
    _leased.remove(task.id);
  }

  @override
  Future<void> retry(QueueTask task, Duration delay) async {
    _tasks[task.id] = task;
    _leased.remove(task.id);
    _notBefore[task.id] = clock.now().add(delay);
  }

  @override
  Future<int> countKind(String kind) async =>
      _tasks.values.where((t) => t.kind == kind).length;

  @override
  Future<int> backlog(Lane lane) async => _tasks.values
      .where((t) => t.lane == lane && !_leased.contains(t.id))
      .length;
}
