import 'dart:io';

/// Переменные окружения с подстановкой из файла `.env` для запуска без Docker.
///
/// Ищет `.env` в текущей папке и выше (корень монорепо). Значения из
/// настоящего окружения важнее файла, поэтому в Docker `.env` ничего не меняет.
Map<String, String> loadEnvironment({Directory? from}) {
  final file = _findDotEnv(from ?? Directory.current);
  return {
    if (file != null) ...parseDotEnv(file.readAsStringSync()),
    ...Platform.environment,
  };
}

File? _findDotEnv(Directory start) {
  Directory? dir = start.absolute;
  while (dir != null) {
    final file = File('${dir.path}${Platform.pathSeparator}.env');
    if (file.existsSync()) return file;
    final parent = dir.parent;
    dir = parent.path == dir.path ? null : parent;
  }
  return null;
}

/// Разбор строк `KEY=value`: пустые строки и `#`-комментарии пропускаются,
/// кавычки вокруг значения снимаются.
Map<String, String> parseDotEnv(String content) {
  final result = <String, String>{};
  for (final raw in content.split(RegExp(r'\r?\n'))) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq <= 0) continue;
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    result[key] = value;
  }
  return result;
}
