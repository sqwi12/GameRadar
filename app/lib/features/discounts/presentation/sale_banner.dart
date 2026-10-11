import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/l10n.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Плашка о распродаже Steam: идёт сейчас (до какого числа) или
/// когда следующая. Без даты в календаре — не показывается.
class SaleBanner extends StatelessWidget {
  const SaleBanner({this.now, super.key});

  /// Для тестов; по умолчанию — текущее время.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final at = (now ?? DateTime.now()).toUtc();
    final active = SteamSales.activeAt(at);
    final sale = active ?? SteamSales.nextAfter(at);
    if (sale == null) return const SizedBox.shrink();

    final dates = DateFormat.MMMd(locale);
    // Конец — момент окончания; последний день распродажи — накануне.
    final lastDay = sale.end.subtract(const Duration(minutes: 1)).toLocal();
    final name = saleName(l10n, sale.kind);
    final days = sale.start.difference(at).inDays;
    final color = active != null
        ? AppColors.discount.resolveFrom(context)
        : AppColors.accent.resolveFrom(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: color.withValues(alpha: 0.35), width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            Icon(
              active != null
                  ? CupertinoIcons.flame_fill
                  : CupertinoIcons.calendar,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                active != null
                    ? l10n.saleActive(name, dates.format(lastDay))
                    : days <= 0
                    ? l10n.saleTomorrow(name)
                    : l10n.saleIn(
                        name,
                        days,
                        '${dates.format(sale.start.toLocal())} – ${dates.format(lastDay)}',
                      ),
                style: AppText.body(context).copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String saleName(AppLocalizations l10n, SteamSaleKind kind) => switch (kind) {
  SteamSaleKind.spring => l10n.saleSpring,
  SteamSaleKind.summer => l10n.saleSummer,
  SteamSaleKind.autumn => l10n.saleAutumn,
  SteamSaleKind.winter => l10n.saleWinter,
};
