import 'package:flutter_test/flutter_test.dart';
import 'package:gameradar_app/core/network/api_urls.dart';

void main() {
  const api = 'http://10.0.2.2:8080';

  test('относительный путь сервера → адрес нашего API', () {
    expect(
      resolveImageUrl('/games/730/header?v=abc', apiBaseUrl: api),
      'http://10.0.2.2:8080/games/730/header?v=abc',
    );
  });

  test('адреса Steam и других доменов не загружаются (правило 1)', () {
    for (final foreign in [
      'https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/730/header.jpg',
      'https://cdn.cloudflare.steamstatic.com/a.jpg',
      'http://10.0.2.2:9999/games/730/header',
      'https://10.0.2.2:8080/games/730/header',
    ]) {
      expect(
        resolveImageUrl(foreign, apiBaseUrl: api),
        isNull,
        reason: foreign,
      );
    }
  });

  test('абсолютный адрес нашего API и пустые значения', () {
    expect(
      resolveImageUrl('http://10.0.2.2:8080/x.jpg', apiBaseUrl: api),
      'http://10.0.2.2:8080/x.jpg',
    );
    expect(resolveImageUrl(null, apiBaseUrl: api), isNull);
    expect(resolveImageUrl('', apiBaseUrl: api), isNull);
  });
}
