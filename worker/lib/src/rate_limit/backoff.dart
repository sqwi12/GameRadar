/// Экспоненциальная пауза хоста после 429/403 (правило 3): 1, 2, 4, 8 минут.
/// Начиная с четвёртого ответа подряд пауза остаётся 8 минут.
final class ThrottleBackoff {
  const ThrottleBackoff({
    this.steps = const [
      Duration(minutes: 1),
      Duration(minutes: 2),
      Duration(minutes: 4),
      Duration(minutes: 8),
    ],
  });

  final List<Duration> steps;

  /// Пауза для [consecutive]-го подряд ответа 429/403 (нумерация с 1).
  Duration pauseFor(int consecutive) {
    if (consecutive < 1) return steps.first;
    return steps[(consecutive - 1).clamp(0, steps.length - 1)];
  }
}

/// Повтор задачи после временной ошибки (сеть, 5xx, битый ответ):
/// 30 с, 1, 2, 4… минут, не больше [max], всего [maxAttempts] попыток.
final class RetryPolicy {
  const RetryPolicy({
    this.base = const Duration(seconds: 30),
    this.max = const Duration(minutes: 30),
    this.maxAttempts = 6,
  });

  final Duration base;
  final Duration max;
  final int maxAttempts;

  /// Задержка перед попыткой номер [attempt] + 1 или null, если попытки кончились.
  Duration? delayAfter(int attempt) {
    if (attempt >= maxAttempts) return null;
    final ms = base.inMilliseconds * (1 << (attempt - 1).clamp(0, 20));
    return Duration(milliseconds: ms.clamp(0, max.inMilliseconds));
  }
}
