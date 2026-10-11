/// Крупная распродажа Steam.
enum SteamSaleKind { spring, summer, autumn, winter }

/// Распродажа Steam: вид и время в UTC [start, end).
typedef SteamSale = ({SteamSaleKind kind, DateTime start, DateTime end});

/// Календарь крупных распродаж Steam.
///
/// Даты — из расписания, которое Valve публикует для разработчиков
/// примерно на полгода вперёд; начало и конец — 10:00 по тихоокеанскому
/// времени (17:00 UTC летом, 18:00 UTC зимой). Когда Valve объявит новые
/// даты, их нужно добавить сюда.
abstract final class SteamSales {
  static final List<SteamSale> all = [
    (
      kind: SteamSaleKind.spring,
      start: DateTime.utc(2026, 3, 19, 17),
      end: DateTime.utc(2026, 3, 26, 17),
    ),
    (
      kind: SteamSaleKind.summer,
      start: DateTime.utc(2026, 6, 25, 17),
      end: DateTime.utc(2026, 7, 9, 17),
    ),
    (
      kind: SteamSaleKind.autumn,
      start: DateTime.utc(2026, 10, 1, 17),
      end: DateTime.utc(2026, 10, 8, 17),
    ),
    (
      kind: SteamSaleKind.winter,
      start: DateTime.utc(2026, 12, 17, 18),
      end: DateTime.utc(2027, 1, 4, 18),
    ),
    (
      kind: SteamSaleKind.spring,
      start: DateTime.utc(2027, 3, 18, 17),
      end: DateTime.utc(2027, 3, 25, 17),
    ),
    (
      kind: SteamSaleKind.summer,
      start: DateTime.utc(2027, 6, 24, 17),
      end: DateTime.utc(2027, 7, 8, 17),
    ),
  ];

  /// Распродажа, которая идёт в момент [now]; null — сейчас нет.
  static SteamSale? activeAt(DateTime now) {
    for (final s in all) {
      if (!now.isBefore(s.start) && now.isBefore(s.end)) return s;
    }
    return null;
  }

  /// Ближайшая будущая распродажа; null — в календаре больше нет дат.
  static SteamSale? nextAfter(DateTime now) {
    for (final s in all) {
      if (now.isBefore(s.start)) return s;
    }
    return null;
  }
}
