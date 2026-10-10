import 'dart:async';

import 'package:gameradar_shared/steam.dart';
import 'package:logging/logging.dart';

import '../clock.dart';
import '../rate_limit/backoff.dart';
import '../steam/steam_client.dart';
import 'task_queue.dart';

/// Цикл обработки одной полосы очереди. Внутри полосы задачи выполняются
/// строго по одной, поэтому одна копия worker не шлёт параллельных запросов
/// к хосту; темп задаёт RateLimiter внутри SteamClient.
final class LaneRunner {
  LaneRunner({
    required this.lane,
    required this._queue,
    required this._handler,
    this._clock = const SystemClock(),
    RetryPolicy retryPolicy = const RetryPolicy(),
    this.idleDelay = const Duration(seconds: 2),
  }) : _retry = retryPolicy,
       _log = Logger('Lane.${lane.name}');

  final Lane lane;
  final TaskQueue _queue;
  final Future<void> Function(QueueTask task) _handler;
  final Clock _clock;
  final RetryPolicy _retry;
  final Duration idleDelay;
  final Logger _log;

  bool _stopped = false;

  void stop() => _stopped = true;

  Future<void> run() async {
    _log.info('Запущена');
    while (!_stopped) {
      try {
        final processed = await runOnce();
        if (!processed) await _clock.sleep(idleDelay);
      } catch (e, st) {
        // Сбой самой очереди (например, Redis недоступен): ждём и пробуем снова.
        _log.severe('Ошибка очереди', e, st);
        await _clock.sleep(const Duration(seconds: 5));
      }
    }
    _log.info('Остановлена');
  }

  /// Обрабатывает одну задачу. false — очередь пуста.
  Future<bool> runOnce() async {
    final task = await _queue.dequeue(lane);
    if (task == null) return false;
    try {
      await _handler(task);
      await _queue.complete(task);
    } on SteamThrottledException catch (e) {
      // Правило 3: задача возвращается в очередь после паузы хоста.
      // Это не ошибка задачи, поэтому попытка не засчитывается.
      await _queue.retry(task, e.pause);
    } on SteamPermanentException catch (e) {
      _log.warning('$task отброшена: $e');
      await _queue.complete(task);
    } catch (e, st) {
      final attempts = task.attempts + 1;
      final delay = _retry.delayAfter(attempts);
      if (delay == null) {
        _log.severe('$task отброшена после $attempts попыток', e, st);
        await _queue.complete(task);
      } else {
        final level = e is SteamTransientException || e is SteamFormatException
            ? Level.WARNING
            : Level.SEVERE;
        _log.log(
          level,
          '$task: попытка $attempts не удалась, повтор через ${delay.inSeconds} с: $e',
        );
        await _queue.retry(task.copyWith(attempts: attempts), delay);
      }
    }
    return true;
  }
}
