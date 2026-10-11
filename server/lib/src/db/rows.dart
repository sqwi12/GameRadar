import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:postgres/postgres.dart';

// Общие куски SQL и разбор строк результата в модели shared.

/// Колонки текущей цены (`p` — game_prices). Порядок важен для [readPrice].
const priceColumns = '''
  p.region::text, p.is_available, p.currency::text, p.initial_price,
  p.final_price, p.discount_pct, p.checked_at, p.changed_at''';

/// Обложка: только сохранённая worker'ом копия (`gi` — game_images).
/// Адрес обложки в Steam приложению не отдаётся никогда (правило 1).
const imageJoin = 'LEFT JOIN game_images gi ON gi.app_id = g.app_id';

/// Наш адрес обложки (относительно API) с версией для кэша приложения.
String? imagePath(int appId, String? etag) =>
    etag == null ? null : '/games/$appId/header?v=$etag';

/// Колонки краткой карточки (`g` — games, `gi` — [imageJoin]) + цена.
/// Порядок важен для [readSummary].
const summaryColumns = '''
  g.app_id, g.name, gi.etag, g.current_players, g.peak_24h, g.top_rank,
  g.is_free,
$priceColumns''';

/// Число колонок, которые занимает [summaryColumns].
const summaryColumnCount = 15;

/// Цена из 8 колонок начиная с [at] или null, если строки game_prices нет.
GamePrice? readPrice(ResultRow row, int at) {
  final region = row[at] as String?;
  if (region == null) return null;
  return GamePrice(
    region: region.trim(),
    isAvailable: row[at + 1]! as bool,
    currency: (row[at + 2] as String?)?.trim(),
    initialPrice: row[at + 3] as int?,
    finalPrice: row[at + 4] as int?,
    discountPct: row[at + 5]! as int,
    checkedAt: row[at + 6]! as DateTime,
    changedAt: row[at + 7]! as DateTime,
  );
}

/// Карточка игры из [summaryColumns], начиная с колонки [at].
GameSummary readSummary(ResultRow row, [int at = 0]) => GameSummary(
  appId: row[at]! as int,
  name: row[at + 1]! as String,
  headerImageUrl: imagePath(row[at]! as int, row[at + 2] as String?),
  currentPlayers: row[at + 3] as int?,
  peak24h: row[at + 4] as int?,
  topRank: row[at + 5] as int?,
  isFree: row[at + 6]! as bool,
  price: readPrice(row, at + 7),
);

/// Экранирует `%`, `_` и `\` для LIKE/ILIKE.
String escapeLike(String text) =>
    text.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');
