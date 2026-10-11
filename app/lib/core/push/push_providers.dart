import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers.dart';
import '../router/app_router.dart';
import '../router/routes.dart';
import 'push_platform.dart';
import 'push_service.dart';

part 'push_providers.g.dart';

@Riverpod(keepAlive: true)
PushPlatform pushPlatform(Ref ref) => FirebasePushPlatform();

/// Push-уведомления. Запускается в main(); по нажатию на уведомление
/// открывается экран игры.
@Riverpod(keepAlive: true)
PushService pushService(Ref ref) {
  final service = PushService(
    platform: ref.watch(pushPlatformProvider),
    api: ref.watch(apiClientProvider),
    openGame: (appId) => ref.read(appRouterProvider).push(Routes.game(appId)),
  );
  ref.onDispose(service.dispose);
  return service;
}
