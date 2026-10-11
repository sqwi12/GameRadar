import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formatters.dart';
import '../../../core/widgets/l10n.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'watchlist_providers.dart';

/// Строка виджета: название, цена и выделение (цель достигнута или скидка).
typedef WidgetRow = ({String name, String price, bool hot});

/// Сколько игр помещается в виджет.
const widgetRows = 4;

/// Игры для виджета: сначала с достигнутой целью, затем с большей скидкой,
/// затем недавно добавленные. Без цены — в конце.
List<WidgetRow> widgetRowsOf(
  List<WatchlistItem> items,
  AppLocalizations l10n,
  String locale,
) {
  int rank(WatchlistItem i) => i.isTargetReached
      ? 0
      : (i.game.price?.isDiscounted ?? false)
      ? 1
      : i.game.price?.finalPrice != null
      ? 2
      : 3;
  final sorted = [...items]
    ..sort((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      if (byRank != 0) return byRank;
      final byDiscount = (b.game.price?.discountPct ?? 0).compareTo(
        a.game.price?.discountPct ?? 0,
      );
      return byDiscount != 0 ? byDiscount : b.createdAt.compareTo(a.createdAt);
    });
  return [
    for (final item in sorted.take(widgetRows))
      (
        name: item.game.name,
        price: switch (item.game.price) {
          _ when item.game.isFree => l10n.priceFree,
          GamePrice(
            isAvailable: true,
            finalPrice: final price?,
            currency: final currency?,
            :final isDiscounted,
            :final discountPct,
          ) =>
            isDiscounted
                ? '${formatPrice(price, currency, locale)} · '
                      '${l10n.discountBadge(discountPct)}'
                : formatPrice(price, currency, locale),
          _ => '—',
        },
        hot: item.isTargetReached || (item.game.price?.isDiscounted ?? false),
      ),
  ];
}

/// Обновляет виджет «Отслеживаю» на рабочем столе Android при каждом
/// изменении списка отслеживания. Без виджета (или не на Android) —
/// ничего не делает.
class HomeWidgetUpdater extends ConsumerStatefulWidget {
  const HomeWidgetUpdater({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<HomeWidgetUpdater> createState() => _HomeWidgetUpdaterState();
}

class _HomeWidgetUpdaterState extends ConsumerState<HomeWidgetUpdater> {
  static const _provider =
      'com.gameradar.gameradar_app.WatchlistWidgetProvider';
  List<WatchlistItem>? _last;

  @override
  void initState() {
    super.initState();
    if (!Platform.isAndroid) return;
    ref.listenManual(watchlistProvider, (_, next) {
      final items = next.data;
      if (items == null || identical(items, _last)) return;
      _last = items;
      unawaited(_push(items));
    }, fireImmediately: true);
  }

  Future<void> _push(List<WatchlistItem> items) async {
    if (!mounted) return;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rows = widgetRowsOf(items, l10n, locale);
    try {
      await HomeWidget.saveWidgetData<int>('count', rows.length);
      for (var i = 0; i < rows.length; i++) {
        await HomeWidget.saveWidgetData<String>('row_${i}_name', rows[i].name);
        await HomeWidget.saveWidgetData<String>(
          'row_${i}_price',
          rows[i].price,
        );
        await HomeWidget.saveWidgetData<bool>('row_${i}_hot', rows[i].hot);
      }
      await HomeWidget.saveWidgetData<String>('title', l10n.widgetTitle);
      await HomeWidget.saveWidgetData<String>('empty', l10n.widgetEmpty);
      await HomeWidget.saveWidgetData<String>(
        'updated',
        DateFormat.Hm(locale).format(DateTime.now()),
      );
      await HomeWidget.updateWidget(qualifiedAndroidName: _provider);
    } on Object {
      // Виджет не главное: ошибка не должна мешать приложению.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
