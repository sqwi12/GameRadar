/// Источник времени. В тестах подменяется на FakeClock,
/// чтобы проверять паузы и лимиты без реального ожидания.
abstract interface class Clock {
  DateTime now();

  Future<void> sleep(Duration duration);
}

final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();

  @override
  Future<void> sleep(Duration duration) =>
      duration <= Duration.zero ? Future.value() : Future.delayed(duration);
}
