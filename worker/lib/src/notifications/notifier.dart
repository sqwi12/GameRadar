import 'package:logging/logging.dart';

/// Данные для push-уведомления о цене.
typedef PriceAlert = ({
  String userId,
  int appId,
  String gameName,
  String locale,
  int finalPrice,
  int? initialPrice,
  int discountPct,
  String currency,
});

/// Отправка уведомлений пользователю на все его устройства.
abstract interface class Notifier {
  /// true — уведомление доставлено хотя бы на одно устройство,
  /// и цену можно запомнить в last_notified_price.
  Future<bool> sendPriceAlert(PriceAlert alert);
}

/// Заглушка до этапа 7 (FCM HTTP v1): только пишет в лог и возвращает false,
/// поэтому last_notified_price не меняется и уведомление не «теряется».
final class LoggingNotifier implements Notifier {
  static final _log = Logger('Notifier');

  @override
  Future<bool> sendPriceAlert(PriceAlert alert) async {
    _log.info(
      'FCM не настроен, уведомление не отправлено: пользователь ${alert.userId}, '
      'app ${alert.appId} (${alert.gameName}), ${alert.finalPrice} ${alert.currency}, '
      '-${alert.discountPct}%',
    );
    return false;
  }
}
