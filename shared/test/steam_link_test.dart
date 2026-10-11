import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:gameradar_shared/steam.dart';
import 'package:test/test.dart';

void main() {
  group('SteamProfileRef.tryParse', () {
    test('SteamID64 и ссылки /profiles/', () {
      const id = SteamId64('76561197960287930');
      for (final input in [
        '76561197960287930',
        ' 76561197960287930 ',
        'https://steamcommunity.com/profiles/76561197960287930/',
        'http://www.steamcommunity.com/profiles/76561197960287930',
        'steamcommunity.com/profiles/76561197960287930/wishlist',
      ]) {
        expect(SteamProfileRef.tryParse(input), id, reason: input);
      }
    });

    test('ник и ссылки /id/', () {
      for (final input in [
        'gabelogannewell',
        'https://steamcommunity.com/id/GabeLoganNewell/',
        'steamcommunity.com/id/gabelogannewell/wishlist/',
      ]) {
        expect(
          SteamProfileRef.tryParse(input),
          const SteamVanity('gabelogannewell'),
          reason: input,
        );
      }
    });

    test('чужие сайты и мусор отклоняются', () {
      for (final input in [
        '',
        'a',
        'https://evil.example.com/id/gabe',
        'https://steamcommunity.com/groups/valve',
        'https://store.steampowered.com/app/730',
        'ник с пробелами',
        'x' * 201,
      ]) {
        expect(SteamProfileRef.tryParse(input), isNull, reason: input);
      }
    });
  });

  test('SteamLinkRequest.validate', () {
    expect(
      const SteamLinkRequest(profile: 'gabelogannewell').validate(),
      isEmpty,
    );
    expect(
      const SteamLinkRequest(
        profile: 'https://evil.com',
        importMinDiscountPct: 0,
      ).validate().map((e) => e.field),
      ['profile', 'import_min_discount_pct'],
    );
  });

  group('парсеры Steam', () {
    test('ResolveVanityURL', () {
      expect(
        parseResolveVanity({
          'response': {'steamid': '76561197960287930', 'success': 1},
        }),
        '76561197960287930',
      );
      expect(
        parseResolveVanity({
          'response': {'success': 42, 'message': 'No match'},
        }),
        isNull,
      );
    });

    test('GetPlayerSummaries: открытый, скрытый, нет профиля', () {
      Map<String, Object?> players(List<Object?> list) => {
        'response': {'players': list},
      };
      final open = parsePlayerSummary(
        players([
          {
            'steamid': '76561197960287930',
            'personaname': 'Gabe',
            'communityvisibilitystate': 3,
          },
        ]),
      )!;
      expect(open.isPublic, isTrue);
      expect(open.personaName, 'Gabe');
      final hidden = parsePlayerSummary(
        players([
          {'steamid': '76561197960287930', 'communityvisibilitystate': 2},
        ]),
      )!;
      expect(hidden.isPublic, isFalse);
      expect(parsePlayerSummary(players([])), isNull);
    });

    test('GetWishlist: порядок по приоритету, пустой и скрытый список', () {
      expect(
        parseWishlist({
          'response': {
            'items': [
              {'appid': 20, 'priority': 2, 'date_added': 1},
              {'appid': 10, 'priority': 1, 'date_added': 2},
              {'appid': 30, 'priority': 0, 'date_added': 3},
              {'appid': 0},
            ],
          },
        }),
        [30, 10, 20],
      );
      expect(parseWishlist({'response': <String, Object?>{}}), isEmpty);
      expect(() => parseWishlist(null), throwsA(isA<SteamFormatException>()));
    });
  });

  test('WatchlistItem.source по умолчанию manual (старые ответы сервера)', () {
    final item = WatchlistItem.fromJson({
      'game': {'app_id': 1, 'name': 'X'},
      'region': 'kz',
      'created_at': '2026-10-11T00:00:00Z',
    });
    expect(item.source, WatchSource.manual);
    expect(
      WatchlistItem.fromJson({...item.toJson(), 'source': 'wishlist'}).source,
      WatchSource.wishlist,
    );
  });
}
