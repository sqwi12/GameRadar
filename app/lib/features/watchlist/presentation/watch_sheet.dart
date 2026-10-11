import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/format/formatters.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/l10n.dart';
import '../../../core/push/push_providers.dart';
import 'watchlist_providers.dart';

/// Открывает стеклянный лист «Уведомить, когда…» для игры.
Future<void> showWatchSheet(
  BuildContext context, {
  required int appId,
  required GamePrice? price,
}) => GlassModalSheet.show<void>(
  context: context,
  halfSize: 0.62,
  builder: (_) => WatchSheet(appId: appId, price: price),
);

/// Пороги уведомления: цена не выше и/или скидка не меньше.
class WatchSheet extends ConsumerStatefulWidget {
  const WatchSheet({required this.appId, required this.price, super.key});

  final int appId;
  final GamePrice? price;

  @override
  ConsumerState<WatchSheet> createState() => _WatchSheetState();
}

class _WatchSheetState extends ConsumerState<WatchSheet> {
  late final WatchlistItem? _existing = ref.read(
    watchItemProvider(widget.appId),
  );
  late final _priceController = TextEditingController(
    text: _existing?.targetPrice == null
        ? ''
        : (_existing!.targetPrice! ~/ minorUnitsPerMajor).toString(),
  );

  /// 0 — скидка не важна.
  late double _minDiscount = (_existing?.minDiscountPct ?? 0).toDouble();
  bool _saving = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _toast(String message, GlassToastType type) => GlassToast.show(
    context,
    message: message,
    type: type,
    position: GlassToastPosition.top,
  );

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _saving = true);
    try {
      await action();
      if (!mounted) return;
      Navigator.of(context).pop();
      _toast(success, GlassToastType.success);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      final error = AppException.from(e);
      _toast(
        error is ApiFailure && error.code == ApiErrorCode.limitExceeded
            ? context.l10n.watchLimit
            : describeError(context.l10n, error),
        GlassToastType.error,
      );
    }
  }

  Future<void> _save() {
    final discount = _minDiscount.round();
    final request = WatchlistUpsertRequest(
      targetPrice: parsePriceInput(_priceController.text),
      minDiscountPct: discount == 0 ? null : discount,
    );
    final hasThresholds =
        request.targetPrice != null || request.minDiscountPct != null;
    return _run(() async {
      await ref.read(watchlistProvider.notifier).save(widget.appId, request);
      // Разрешение на уведомления спрашиваем в момент, когда оно нужно:
      // пользователь только что задал порог цены.
      if (hasThresholds) {
        await ref.read(pushServiceProvider).requestPermission();
      }
    }, context.l10n.watchSaved);
  }

  Future<void> _remove() => _run(
    () => ref.read(watchlistProvider.notifier).remove(widget.appId),
    context.l10n.watchRemoved,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final price = widget.price;
    final discount = _minDiscount.round();
    // Текст на бирюзовой кнопке: тёмный в тёмной теме (там акцент светлый).
    final onAccent = CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? const Color(0xFF06121C)
        : CupertinoColors.white;
    final hasThresholds =
        parsePriceInput(_priceController.text) != null || discount > 0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.watchSheetTitle,
            style: AppText.largeTitle(context).copyWith(fontSize: 24),
          ),
          if (price?.finalPrice != null && price?.currency != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.watchCurrentPrice(
                formatPrice(price!.finalPrice!, price.currency!, locale),
              ),
              style: AppText.secondary(context),
            ),
          ],
          const SizedBox(height: 20),
          Text(l10n.targetPriceLabel, style: AppText.sectionHeader(context)),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _priceController,
            placeholder: l10n.targetPricePlaceholder,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text('₸'),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            style: AppText.body(context),
            decoration: BoxDecoration(
              color: AppColors.card.resolveFrom(context),
              borderRadius: BorderRadius.circular(14),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.minDiscountLabel,
                  style: AppText.sectionHeader(context),
                ),
              ),
              Text(
                discount == 0 ? l10n.minDiscountOff : '$discount%',
                style: AppText.title(context).copyWith(
                  color: discount == 0
                      ? null
                      : AppColors.discount.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          GlassSlider(
            value: _minDiscount,
            max: 90,
            divisions: 18,
            activeColor: AppColors.discount.resolveFrom(context),
            onChanged: (v) => setState(() => _minDiscount = v),
            useOwnLayer: true,
          ),
          if (!hasThresholds) ...[
            const SizedBox(height: 8),
            Text(
              l10n.watchNoThresholds,
              style: AppText.secondary(context).copyWith(fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: CupertinoButton.filled(
              onPressed: _saving ? null : _save,
              borderRadius: BorderRadius.circular(25),
              child: _saving
                  ? CupertinoActivityIndicator(color: onAccent)
                  : Text(
                      l10n.save,
                      style: AppText.title(context).copyWith(color: onAccent),
                    ),
            ),
          ),
          if (_existing != null) ...[
            const SizedBox(height: 8),
            CupertinoButton(
              onPressed: _saving ? null : _remove,
              child: Text(
                l10n.removeFromWatchlist,
                style: const TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
