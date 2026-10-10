import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:test/test.dart';

void main() {
  group('ClockTime', () {
    test('разбирает HH:mm и HH:mm:ss', () {
      expect(ClockTime.parse('07:05'), const ClockTime(7, 5));
      expect(ClockTime.parse('23:59:00'), const ClockTime(23, 59));
    });

    test('форматирует с ведущими нулями', () {
      expect(const ClockTime(7, 5).toString(), '07:05');
    });

    test('отклоняет неверный формат', () {
      for (final bad in [
        '7:05',
        '24:00',
        '12:60',
        '',
        'aa:bb',
        '12:00:00:00',
      ]) {
        expect(() => ClockTime.parse(bad), throwsFormatException, reason: bad);
      }
    });
  });

  group('QuietHours.contains', () {
    const night = QuietHours(start: ClockTime(23, 0), end: ClockTime(8, 0));
    const day = QuietHours(start: ClockTime(13, 0), end: ClockTime(15, 30));

    test('интервал через полночь', () {
      expect(night.contains(const ClockTime(23, 0)), isTrue);
      expect(night.contains(const ClockTime(2, 0)), isTrue);
      expect(night.contains(const ClockTime(7, 59)), isTrue);
      expect(night.contains(const ClockTime(8, 0)), isFalse);
      expect(night.contains(const ClockTime(22, 59)), isFalse);
      expect(night.contains(const ClockTime(12, 0)), isFalse);
    });

    test('интервал внутри суток', () {
      expect(day.contains(const ClockTime(13, 0)), isTrue);
      expect(day.contains(const ClockTime(15, 29)), isTrue);
      expect(day.contains(const ClockTime(15, 30)), isFalse);
      expect(day.contains(const ClockTime(12, 59)), isFalse);
    });

    test('start == end — тихих часов нет', () {
      const empty = QuietHours(start: ClockTime(9, 0), end: ClockTime(9, 0));
      expect(empty.contains(const ClockTime(9, 0)), isFalse);
      expect(empty.contains(const ClockTime(3, 0)), isFalse);
    });

    test('JSON в формате HH:mm', () {
      expect(night.toJson(), {'start': '23:00', 'end': '08:00'});
      expect(QuietHours.fromJson({'start': '23:00', 'end': '08:00'}), night);
    });
  });
}
