import 'dart:async';

import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../watchlist/presentation/watchlist_providers.dart';
import '../data/steam_link_repository.dart';
import 'settings_providers.dart';

part 'steam_providers.g.dart';

@Riverpod(keepAlive: true)
SteamLinkRepository steamLinkRepository(Ref ref) =>
    SteamLinkRepository(ref.watch(apiClientProvider));

/// Привязанный профиль Steam (null — не привязан).
///
/// Пока импорт в очереди (pending), статус опрашивается раз в 5 секунд;
/// когда worker закончит, список отслеживания перезагружается. Провайдер
/// живёт всё время работы приложения, чтобы импорт, начатый в настройках,
/// обновил список, даже если пользователь уже ушёл с экрана.
@Riverpod(keepAlive: true, retry: noRetry)
class SteamConnection extends _$SteamConnection {
  static const _pollInterval = Duration(seconds: 5);

  /// Worker берёт новые привязки каждую минуту; если за 5 минут импорт
  /// не завершился, опрос останавливается до следующего открытия настроек.
  static const _maxPolls = 60;

  Timer? _timer;
  int _polls = 0;

  @override
  Future<SteamLink?> build() async {
    ref.onDispose(() => _timer?.cancel());
    final link = await ref.watch(steamLinkRepositoryProvider).fetch();
    _polls = 0;
    _schedule(link);
    return link;
  }

  Future<void> save(SteamLinkRequest request) async {
    final link = await ref.read(steamLinkRepositoryProvider).save(request);
    state = AsyncData(link);
    _polls = 0;
    _schedule(link);
  }

  Future<void> unlink() async {
    await ref.read(steamLinkRepositoryProvider).unlink();
    _timer?.cancel();
    state = const AsyncData(null);
    await ref.read(watchlistProvider.notifier).reload();
  }

  void _schedule(SteamLink? link) {
    _timer?.cancel();
    if (link?.status != SteamLinkStatus.pending || _polls >= _maxPolls) return;
    _timer = Timer(_pollInterval, _poll);
  }

  Future<void> _poll() async {
    _polls++;
    SteamLink? link;
    try {
      link = await ref.read(steamLinkRepositoryProvider).fetch();
    } on Object {
      // Нет связи — пробуем на следующем шаге, текущий статус не меняем.
      _schedule(state.value);
      return;
    }
    state = AsyncData(link);
    if (link?.status == SteamLinkStatus.ok) {
      await ref.read(watchlistProvider.notifier).reload();
    }
    _schedule(link);
  }
}
