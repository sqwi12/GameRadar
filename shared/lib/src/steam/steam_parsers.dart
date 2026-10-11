import 'steam_models.dart';

// Разбор ответов Steam. Все функции принимают уже декодированный JSON
// (`jsonDecode(body)`) и бросают SteamFormatException, если структура
// не похожа на ожидаемую. Отсутствие данных об игре — не ошибка.

Map<String, Object?> _asMap(Object? value, String what) {
  if (value is Map<String, Object?>) return value;
  throw SteamFormatException(
    '$what: ожидался объект, получено ${value.runtimeType}',
  );
}

int? _asInt(Object? value) => switch (value) {
  final int v => v,
  final double v when v == v.roundToDouble() => v.toInt(),
  final String v => int.tryParse(v),
  _ => null,
};

String? _asNonEmptyString(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

List<String> _stringList(Object? value) =>
    value is List ? value.map(_asNonEmptyString).nonNulls.toList() : const [];

/// `GET store.steampowered.com/api/appdetails?appids=1,2,3&filters=price_overview&cc=kz`
///
/// Формат ответа:
/// ```json
/// {"10": {"success": true, "data": {"price_overview": {...}}},
///  "20": {"success": true, "data": []},      // цены нет (например, бесплатная)
///  "30": {"success": false}}                 // нет в регионе / неизвестна
/// ```
/// Возвращает результаты только для appid, которые есть в ответе.
/// При перегрузке Steam иногда отвечает `null` — это SteamFormatException.
Map<int, SteamPriceOverview> parsePriceOverviewBatch(Object? json) {
  final root = _asMap(json, 'appdetails');
  final result = <int, SteamPriceOverview>{};
  for (final MapEntry(:key, :value) in root.entries) {
    final appId = int.tryParse(key);
    if (appId == null) continue;
    final entry = _asMap(value, 'appdetails[$key]');
    if (entry['success'] != true) {
      result[appId] = SteamPriceOverview(appId: appId, success: false);
      continue;
    }
    final data = entry['data'];
    final overview = data is Map<String, Object?>
        ? data['price_overview']
        : null;
    if (overview is! Map<String, Object?>) {
      result[appId] = SteamPriceOverview(appId: appId, success: true);
      continue;
    }
    final currency = _asNonEmptyString(overview['currency']);
    final initial = _asInt(overview['initial']);
    final finalPrice = _asInt(overview['final']);
    if (currency == null || initial == null || finalPrice == null) {
      throw SteamFormatException('price_overview[$key]: неполные данные');
    }
    result[appId] = SteamPriceOverview(
      appId: appId,
      success: true,
      currency: currency.toUpperCase(),
      initialPrice: initial,
      finalPrice: finalPrice,
      discountPct: (_asInt(overview['discount_percent']) ?? 0).clamp(0, 100),
    );
  }
  return result;
}

/// `GET store.steampowered.com/api/appdetails?appids=730&l=english`
///
/// Возвращает null, если Steam не отдаёт данные об игре (`success: false`).
SteamAppDetails? parseAppDetails(Object? json, int appId) {
  final root = _asMap(json, 'appdetails');
  final entry = _asMap(root['$appId'], 'appdetails[$appId]');
  if (entry['success'] != true) return null;
  final data = _asMap(entry['data'], 'appdetails[$appId].data');

  final name = _asNonEmptyString(data['name']);
  if (name == null) throw SteamFormatException('appdetails[$appId]: нет name');

  final release = data['release_date'];
  final releaseMap = release is Map<String, Object?>
      ? release
      : const <String, Object?>{};
  final genres = data['genres'];

  return SteamAppDetails(
    appId: appId,
    name: decodeHtmlEntities(name),
    type: _asNonEmptyString(data['type']) ?? 'unknown',
    isFree: data['is_free'] == true,
    shortDescription: switch (_asNonEmptyString(data['short_description'])) {
      final String text => decodeHtmlEntities(text),
      null => null,
    },
    headerImageUrl: _asNonEmptyString(data['header_image']),
    developers: _stringList(data['developers']),
    publishers: _stringList(data['publishers']),
    genres: genres is List
        ? genres
              .whereType<Map<String, Object?>>()
              .map((g) => _asNonEmptyString(g['description']))
              .nonNulls
              .toList()
        : const [],
    releaseDate: switch (releaseMap['date']) {
      final String date => parseSteamReleaseDate(date),
      _ => null,
    },
    comingSoon: releaseMap['coming_soon'] == true,
  );
}

/// Только краткое описание из `appdetails` на другом языке (`l=russian`).
String? parseShortDescription(Object? json, int appId) {
  final root = _asMap(json, 'appdetails');
  final entry = _asMap(root['$appId'], 'appdetails[$appId]');
  if (entry['success'] != true) return null;
  final data = _asMap(entry['data'], 'appdetails[$appId].data');
  return switch (_asNonEmptyString(data['short_description'])) {
    final String text => decodeHtmlEntities(text),
    null => null,
  };
}

const _months = {
  'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6, //
  'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
};

final _dayMonthYear = RegExp(
  r'^(\d{1,2})\s+([A-Za-z]{3})[A-Za-z]*\.?,?\s+(\d{4})$',
);
final _monthDayYear = RegExp(
  r'^([A-Za-z]{3})[A-Za-z]*\.?\s+(\d{1,2}),?\s+(\d{4})$',
);

/// Дата релиза из `release_date.date` (запрос с `l=english`).
/// Понимает `21 Aug, 2012`, `Aug 21, 2012`, `21 August 2012`.
/// Неточные даты (`Q1 2025`, `2025`, `Coming soon`) дают null.
DateTime? parseSteamReleaseDate(String value) {
  final text = value.trim();
  int? day;
  String? month;
  int? year;
  if (_dayMonthYear.firstMatch(text) case final m?) {
    day = int.parse(m.group(1)!);
    month = m.group(2);
    year = int.parse(m.group(3)!);
  } else if (_monthDayYear.firstMatch(text) case final m?) {
    month = m.group(1);
    day = int.parse(m.group(2)!);
    year = int.parse(m.group(3)!);
  } else {
    return null;
  }
  final monthNumber = _months[month!.toLowerCase()];
  if (monthNumber == null || day < 1 || day > 31) return null;
  final date = DateTime.utc(year, monthNumber, day);
  // Отсекаем несуществующие даты вроде 31 Feb (DateTime переносит их на март).
  return date.month == monthNumber ? date : null;
}

/// `GET store.steampowered.com/appreviews/730?json=1&language=all&purchase_type=all&num_per_page=0`
SteamReviewSummary parseReviewSummary(Object? json) {
  final root = _asMap(json, 'appreviews');
  if (_asInt(root['success']) != 1) {
    throw SteamFormatException('appreviews: success != 1');
  }
  final summary = _asMap(root['query_summary'], 'appreviews.query_summary');
  final positive = _asInt(summary['total_positive']);
  final total = _asInt(summary['total_reviews']);
  if (positive == null || total == null) {
    throw SteamFormatException('appreviews: нет total_positive/total_reviews');
  }
  return SteamReviewSummary(totalPositive: positive, totalReviews: total);
}

/// `GET api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?appid=730`
///
/// `{"response": {"player_count": 123, "result": 1}}`. Если у игры нет
/// статистики, Steam отвечает `{"response": {"result": 42}}` (часто с HTTP 404) —
/// тогда возвращается null.
int? parseCurrentPlayers(Object? json) {
  final root = _asMap(json, 'GetNumberOfCurrentPlayers');
  final response = _asMap(
    root['response'],
    'GetNumberOfCurrentPlayers.response',
  );
  if (_asInt(response['result']) != 1) return null;
  final count = _asInt(response['player_count']);
  if (count == null || count < 0) {
    throw SteamFormatException('GetNumberOfCurrentPlayers: нет player_count');
  }
  return count;
}

/// `GET api.steampowered.com/IStoreService/GetAppList/v1/?include_games=true&last_appid=...`
SteamAppListPage parseAppListPage(Object? json) {
  final root = _asMap(json, 'GetAppList');
  final response = _asMap(root['response'], 'GetAppList.response');
  final apps = response['apps'];
  return SteamAppListPage(
    apps: apps is List
        ? [
            for (final app in apps.whereType<Map<String, Object?>>())
              if ((_asInt(app['appid']), _asNonEmptyString(app['name']))
                  case (final int id, final String name) when id > 0)
                SteamAppListEntry(appId: id, name: decodeHtmlEntities(name)),
          ]
        : const [],
    haveMoreResults: response['have_more_results'] == true,
    lastAppId: _asInt(response['last_appid']),
  );
}

/// `GET api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?vanityurl=...`
///
/// `{"response": {"steamid": "765...", "success": 1}}`; ника нет —
/// `{"response": {"success": 42, "message": "No match"}}` → null.
String? parseResolveVanity(Object? json) {
  final root = _asMap(json, 'ResolveVanityURL');
  final response = _asMap(root['response'], 'ResolveVanityURL.response');
  if (_asInt(response['success']) != 1) return null;
  final id = _asNonEmptyString(response['steamid']);
  if (id == null) throw SteamFormatException('ResolveVanityURL: нет steamid');
  return id;
}

/// `GET api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?steamids=...`
/// null — профиля нет.
SteamPlayerSummary? parsePlayerSummary(Object? json) {
  final root = _asMap(json, 'GetPlayerSummaries');
  final response = _asMap(root['response'], 'GetPlayerSummaries.response');
  final players = response['players'];
  if (players is! List) {
    throw SteamFormatException('GetPlayerSummaries: нет players');
  }
  final player = players.whereType<Map<String, Object?>>().firstOrNull;
  if (player == null) return null;
  return SteamPlayerSummary(
    steamId: _asNonEmptyString(player['steamid']) ?? '',
    personaName: _asNonEmptyString(player['personaname']),
    // 3 — профиль открыт; 1 и 2 — скрыт или только для друзей.
    isPublic: _asInt(player['communityvisibilitystate']) == 3,
  );
}

/// `GET api.steampowered.com/IWishlistService/GetWishlist/v1/?steamid=...`
///
/// `{"response": {"items": [{"appid": 1091500, "priority": 1, "date_added": ...}]}}`.
/// Скрытый или пустой список — `{"response": {}}` → пустой список.
/// Порядок — как в списке желаемого пользователя (по priority).
List<int> parseWishlist(Object? json) {
  final root = _asMap(json, 'GetWishlist');
  final response = _asMap(root['response'], 'GetWishlist.response');
  final items = response['items'];
  if (items == null) return const [];
  if (items is! List) {
    throw SteamFormatException('GetWishlist: items не список');
  }
  final rows = [
    for (final item in items.whereType<Map<String, Object?>>())
      if (_asInt(item['appid']) case final int appId when appId > 0)
        (appId: appId, priority: _asInt(item['priority']) ?? 1 << 30),
  ]..sort((a, b) => a.priority.compareTo(b.priority));
  return [for (final r in rows) r.appId];
}

/// `GET api.steampowered.com/ISteamChartsService/GetGamesByConcurrentPlayers/v1/`
List<SteamChartEntry> parseConcurrentPlayersChart(Object? json) {
  final root = _asMap(json, 'GetGamesByConcurrentPlayers');
  final response = _asMap(
    root['response'],
    'GetGamesByConcurrentPlayers.response',
  );
  final ranks = response['ranks'];
  if (ranks is! List) {
    throw SteamFormatException('GetGamesByConcurrentPlayers: нет ranks');
  }
  return [
    for (final row in ranks.whereType<Map<String, Object?>>())
      if ((
            _asInt(row['rank']),
            _asInt(row['appid']),
            _asInt(row['concurrent_in_game']),
          )
          case (final int rank, final int appId, final int concurrent))
        SteamChartEntry(
          rank: rank,
          appId: appId,
          concurrentInGame: concurrent,
          peakInGame: _asInt(row['peak_in_game']),
        ),
  ];
}

const _namedEntities = {
  'amp': '&', 'lt': '<', 'gt': '>', 'quot': '"', 'apos': "'", //
  'nbsp': ' ', 'laquo': '«', 'raquo': '»', 'mdash': '—', 'ndash': '–',
  'hellip': '…', 'trade': '™', 'reg': '®', 'copy': '©',
};

final _entity = RegExp(r'&(#\d+|#x[0-9a-fA-F]+|[a-z]+);');

/// Декодирует HTML-сущности, которые встречаются в текстах Steam.
String decodeHtmlEntities(String text) => text.replaceAllMapped(_entity, (m) {
  final code = m.group(1)!;
  if (code.startsWith('#x')) {
    return String.fromCharCode(int.parse(code.substring(2), radix: 16));
  }
  if (code.startsWith('#')) {
    return String.fromCharCode(int.parse(code.substring(1)));
  }
  // Неизвестную именованную сущность оставляем как есть.
  return _namedEntities[code] ?? m.group(0)!;
});
