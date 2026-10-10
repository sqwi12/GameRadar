import '../clock.dart';

/// Ограничитель запросов к хостам Steam (правило 2): не чаще одного
/// запроса в [interval] на хост, плюс пауза хоста после 429/403 (правило 3).
abstract interface class RateLimiter {
  /// Резервирует ближайший слот для запроса к [host] и возвращает,
  /// сколько нужно подождать до него. Вызывающий обязан выждать это время.
  Future<Duration> reserve(String host);

  /// Ставит хост на паузу на [duration] от текущего момента:
  /// слоты раньше её конца не выдаются (в том числе уже зарезервированные).
  Future<void> pause(String host, Duration duration);

  /// Сколько раз подряд хост ответил 429/403 (для экспоненциальной паузы).
  Future<int> registerThrottle(String host);

  /// Успешный ответ сбрасывает счётчик подряд идущих 429/403.
  Future<void> registerSuccess(String host);
}

/// Результат резервирования слота.
typedef SlotReservation = ({int waitMs, int nextAllowedMs});

/// Чистая логика резервирования слота, общая для памяти и Redis
/// (Lua-скрипт в RedisRateLimiter повторяет её один в один).
///
/// [nextAllowedMs] — раньше этого момента новый запрос не выдаётся (0 — никогда
/// не было запросов), [pausedUntilMs] — конец паузы после 429/403 (0 — паузы нет).
/// Слот = max(now, nextAllowed, pausedUntil); следующий слот = слот + interval.
SlotReservation reserveSlot({
  required int nowMs,
  required int nextAllowedMs,
  required int pausedUntilMs,
  required int intervalMs,
}) {
  var slot = nowMs;
  if (nextAllowedMs > slot) slot = nextAllowedMs;
  if (pausedUntilMs > slot) slot = pausedUntilMs;
  return (waitMs: slot - nowMs, nextAllowedMs: slot + intervalMs);
}

/// Ограничитель в памяти процесса: для тестов и запуска одной копии без Redis.
final class InMemoryRateLimiter implements RateLimiter {
  InMemoryRateLimiter({required this.interval, required this.clock});

  final Duration interval;
  final Clock clock;

  final _nextAllowed = <String, int>{};
  final _pausedUntil = <String, int>{};
  final _throttles = <String, int>{};

  @override
  Future<Duration> reserve(String host) async {
    final r = reserveSlot(
      nowMs: clock.now().millisecondsSinceEpoch,
      nextAllowedMs: _nextAllowed[host] ?? 0,
      pausedUntilMs: _pausedUntil[host] ?? 0,
      intervalMs: interval.inMilliseconds,
    );
    _nextAllowed[host] = r.nextAllowedMs;
    return Duration(milliseconds: r.waitMs);
  }

  @override
  Future<void> pause(String host, Duration duration) async {
    final ms = clock.now().add(duration).millisecondsSinceEpoch;
    if (ms > (_pausedUntil[host] ?? 0)) _pausedUntil[host] = ms;
    // Слоты, выданные до паузы, тоже переносятся за её конец.
    if ((_nextAllowed[host] ?? 0) < ms) _nextAllowed[host] = ms;
  }

  @override
  Future<int> registerThrottle(String host) async =>
      _throttles[host] = (_throttles[host] ?? 0) + 1;

  @override
  Future<void> registerSuccess(String host) async => _throttles.remove(host);
}
