// Тестовое push-уведомление: проверка настройки Firebase без ожидания
// снижения цены. Отправляет на устройства пользователя, который последним
// зарегистрировал FCM-токен (обычно это эмулятор или телефон разработчика).
//
// Запуск из папки worker (настройки из .env):
//   dart run tool/send_test_push.dart [app_id]
import 'dart:io';

import 'package:gameradar_worker/gameradar_worker.dart';
import 'package:postgres/postgres.dart';

Future<void> main(List<String> args) async {
  final config = WorkerConfig.fromEnvironment();
  if (!config.fcmConfigured) {
    stderr.writeln(
      'FCM не настроен: задайте FCM_PROJECT_ID и FCM_SERVICE_ACCOUNT_FILE в .env',
    );
    exit(64);
  }
  final appId = args.isEmpty ? 1091500 : int.parse(args.first);
  final db = Pool<void>.withUrl(config.databaseUrl);
  try {
    final rows = await db.execute(
      Sql.named('''
        SELECT d.user_id::text, u.locale, g.name
        FROM devices d
        JOIN users u ON u.id = d.user_id
        JOIN games g ON g.app_id = @app:int4
        ORDER BY d.updated_at DESC
        LIMIT 1
      '''),
      parameters: {'app': appId},
    );
    if (rows.isEmpty) {
      stderr.writeln(
        'Нет ни одного устройства: откройте приложение и разрешите уведомления',
      );
      exit(1);
    }
    final [userId, locale, name] = rows.first;
    final notifier = await FcmNotifier.fromServiceAccountFile(
      projectId: config.fcmProjectId!,
      path: config.fcmServiceAccountFile!,
      devices: DevicesRepository(db),
    );
    final sent = await notifier.sendPriceAlert((
      userId: userId! as String,
      appId: appId,
      gameName: name! as String,
      locale: locale! as String,
      finalPrice: 899900,
      initialPrice: 1799900,
      discountPct: 50,
      currency: 'KZT',
    ));
    stdout.writeln(sent ? 'Отправлено' : 'Не доставлено (см. журнал выше)');
    exit(sent ? 0 : 1);
  } finally {
    await db.close();
  }
}
