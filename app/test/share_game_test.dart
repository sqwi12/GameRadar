import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/features/game/presentation/share_game.dart';
import 'package:gameradar_app/l10n/gen/app_localizations.dart';
import 'package:gameradar_shared/gameradar_shared.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ru'));

  test('поделиться: название, цена со скидкой и страница в Steam', () {
    final game = GameDetails(
      appId: 1142710,
      name: 'Total War: WARHAMMER III',
      price: GamePrice(
        region: 'kz',
        isAvailable: true,
        currency: 'KZT',
        initialPrice: 2250000,
        finalPrice: 337500,
        discountPct: 85,
        checkedAt: DateTime.utc(2026, 10, 12),
        changedAt: DateTime.utc(2026, 10, 12),
      ),
    );
    final lines = shareGameText(l10n, game, 'ru').split('\n');
    expect(lines.first, startsWith('Total War: WARHAMMER III — 3'));
    expect(lines.first, endsWith('(−85%)'));
    expect(lines[1], 'https://store.steampowered.com/app/1142710');
    expect(lines.last, 'Нашёл в GameRadar');
  });

  test('ссылка на игру в приложении', () {
    expect(gameDeepLink(730).toString(), 'gameradar://app/game/730');
    expect(gameDeepLink(730).path, '/game/730');
  });
}
