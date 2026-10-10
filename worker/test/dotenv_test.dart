import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:test/test.dart';

void main() {
  test('parseDotEnv: комментарии, пустые строки, кавычки, = в значении', () {
    expect(
      parseDotEnv('''
# комментарий
A=1

B = "два слова"
C='x=y'
DATABASE_URL=postgres://u:p@h:5432/db?sslmode=disable
BROKEN
'''),
      {
        'A': '1',
        'B': 'два слова',
        'C': 'x=y',
        'DATABASE_URL': 'postgres://u:p@h:5432/db?sslmode=disable',
      },
    );
  });
}
