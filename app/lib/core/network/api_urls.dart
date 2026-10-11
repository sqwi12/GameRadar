import '../config/app_config.dart';

/// Адрес картинки для загрузки. Сервер отдаёт пути относительно API
/// (`/games/730/header?v=...`): обложки хранит наш сервер, а приложение
/// никогда не обращается к Steam (правило 1). Абсолютный адрес на чужой
/// домен отклоняется, даже если пришёл, — вместо картинки будет заглушка.
String? resolveImageUrl(
  String? url, {
  String apiBaseUrl = AppConfig.apiBaseUrl,
}) {
  if (url == null || url.isEmpty) return null;
  final api = Uri.parse(apiBaseUrl);
  final parsed = Uri.tryParse(url);
  if (parsed == null) return null;
  if (!parsed.hasScheme) return api.resolveUri(parsed).toString();
  final sameOrigin =
      parsed.scheme == api.scheme &&
      parsed.host == api.host &&
      parsed.port == api.port;
  return sameOrigin ? url : null;
}
