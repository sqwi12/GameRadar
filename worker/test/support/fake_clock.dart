import 'package:gameradar_worker/gameradar_worker.dart';

/// Управляемые часы: sleep() мгновенно сдвигает время и запоминает паузы.
final class FakeClock implements Clock {
  FakeClock([DateTime? start]) : _now = start ?? DateTime.utc(2026, 10, 11, 12);

  DateTime _now;
  final sleeps = <Duration>[];

  @override
  DateTime now() => _now;

  void advance(Duration d) => _now = _now.add(d);

  @override
  Future<void> sleep(Duration duration) async {
    sleeps.add(duration);
    if (duration > Duration.zero) advance(duration);
  }
}
