import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/l10n.dart';
import 'steam_providers.dart';
import '../../../core/widgets/app_controls.dart';

/// Раздел «Steam»: импорт списка желаемого по ссылке на профиль.
/// Вход через Steam не нужен — профиль должен быть открытым.
class SteamSection extends ConsumerWidget {
  const SteamSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final connection = ref.watch(steamConnectionProvider);
    final link = connection.value;
    return AppGroupedSection(
      header: Text(l10n.steamSection.toUpperCase()),
      footer: Text(l10n.steamSectionFooter),
      children: [
        AppListTile(
          leading: const Icon(CupertinoIcons.gift),
          title: Text(l10n.steamImportTitle),
          subtitle: Text(switch (connection) {
            AsyncError(:final error) => describeError(l10n, error),
            AsyncData() => steamStatusText(context, link),
            _ => l10n.accountConnecting,
          }),
          trailing: switch (connection) {
            AsyncError() => Icon(
              CupertinoIcons.arrow_clockwise,
              color: CupertinoColors.systemRed.resolveFrom(context),
            ),
            AsyncData() when link?.status == SteamLinkStatus.pending =>
              const CupertinoActivityIndicator(),
            AsyncData() => _StatusIcon(link?.status),
            _ => const CupertinoActivityIndicator(),
          },
          onTap: switch (connection) {
            AsyncError() => () => ref.invalidate(steamConnectionProvider),
            AsyncData() => () => GlassModalSheet.show<void>(
              context: context,
              halfSize: 0.8,
              builder: (_) => _SteamSheet(initial: link),
            ),
            _ => null,
          },
        ),
      ],
    );
  }
}

/// Строка состояния привязки для плитки и листа.
String steamStatusText(BuildContext context, SteamLink? link) {
  final l10n = context.l10n;
  if (link == null) return l10n.steamNotLinked;
  return switch (link.status) {
    SteamLinkStatus.pending => l10n.steamPending,
    SteamLinkStatus.privateProfile => l10n.steamPrivate,
    SteamLinkStatus.notFound => l10n.steamNotFound,
    SteamLinkStatus.ok => [
      l10n.steamImported(
        link.personaName ?? link.steamId ?? link.profileInput,
        link.importedCount ?? 0,
        link.wishlistCount ?? 0,
      ),
      if (link.syncedAt case final at?)
        DateFormat.MMMd(Localizations.localeOf(context).toLanguageTag())
            .add_Hm()
            .format(at.toLocal()),
    ].join(' · '),
  };
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon(this.status);

  final SteamLinkStatus? status;

  @override
  Widget build(BuildContext context) => switch (status) {
    SteamLinkStatus.ok => Icon(
      CupertinoIcons.checkmark_seal_fill,
      color: AppColors.discount.resolveFrom(context),
    ),
    SteamLinkStatus.privateProfile || SteamLinkStatus.notFound => Icon(
      CupertinoIcons.exclamationmark_triangle_fill,
      color: CupertinoColors.systemOrange.resolveFrom(context),
    ),
    _ => AppListTile.chevron,
  };
}

/// Лист привязки: ссылка или ник, порог скидки, импорт и отвязка.
class _SteamSheet extends ConsumerStatefulWidget {
  const _SteamSheet({required this.initial});

  final SteamLink? initial;

  @override
  ConsumerState<_SteamSheet> createState() => _SteamSheetState();
}

class _SteamSheetState extends ConsumerState<_SteamSheet> {
  static const _discounts = [25, 50, 75];

  late final _input = TextEditingController(text: widget.initial?.profileInput);
  late int _discount =
      widget.initial?.importMinDiscountPct ??
      SteamLinkRequest.defaultMinDiscount;
  bool _busy = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _toast(String message, GlassToastType type) => GlassToast.show(
    context,
    message: message,
    type: type,
    position: GlassToastPosition.top,
  );

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      Navigator.of(context).pop();
      _toast(success, GlassToastType.success);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _toast(describeError(context.l10n, e), GlassToastType.error);
    }
  }

  Future<void> _import() => _run(
    () => ref
        .read(steamConnectionProvider.notifier)
        .save(
          SteamLinkRequest(
            profile: _input.text.trim(),
            importMinDiscountPct: _discount,
          ),
        ),
    context.l10n.steamImportStarted,
  );

  Future<void> _unlink() async {
    final l10n = context.l10n;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.steamUnlink),
        content: Text(l10n.steamUnlinkHint),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.steamUnlinkConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run(
      () => ref.read(steamConnectionProvider.notifier).unlink(),
      l10n.steamUnlinked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final link = ref.watch(steamConnectionProvider).value ?? widget.initial;
    final text = _input.text.trim();
    final valid = SteamProfileRef.tryParse(text) != null;
    final changed =
        link == null ||
        text != link.profileInput ||
        _discount != link.importMinDiscountPct;
    final discounts = {..._discounts, _discount}.toList()..sort();
    final onAccent = CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? const Color(0xFF06121C)
        : CupertinoColors.white;

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
            l10n.steamImportTitle,
            style: AppText.largeTitle(context).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(l10n.steamSheetIntro, style: AppText.secondary(context)),
          if (link != null) ...[
            const SizedBox(height: 16),
            _StatusCard(link: link),
          ],
          const SizedBox(height: 20),
          Text(l10n.steamProfileLabel, style: AppText.sectionHeader(context)),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _input,
            placeholder: l10n.steamProfilePlaceholder,
            keyboardType: TextInputType.url,
            autocorrect: false,
            enableSuggestions: false,
            clearButtonMode: OverlayVisibilityMode.editing,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            style: AppText.body(context),
            decoration: BoxDecoration(
              color: AppColors.card.resolveFrom(context),
              borderRadius: BorderRadius.circular(14),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (text.isNotEmpty && !valid) ...[
            const SizedBox(height: 6),
            Text(
              l10n.steamProfileInvalid,
              style: AppText.secondary(context).copyWith(
                fontSize: 13,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.steamImportDiscountLabel,
            style: AppText.sectionHeader(context),
          ),
          const SizedBox(height: 8),
          AppSegmentedControl(
            labels: [for (final d in discounts) '$d%'],
            selectedIndex: discounts.indexOf(_discount),
            onSelected: (i) => setState(() => _discount = discounts[i]),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.steamImportDiscountHint,
            style: AppText.secondary(context).copyWith(fontSize: 13),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: CupertinoButton.filled(
              onPressed: _busy || !valid ? null : _import,
              borderRadius: BorderRadius.circular(25),
              child: _busy
                  ? CupertinoActivityIndicator(color: onAccent)
                  : Text(
                      link == null
                          ? l10n.steamImportButton
                          : changed
                          ? l10n.save
                          : l10n.steamResyncButton,
                      style: AppText.title(context).copyWith(color: onAccent),
                    ),
            ),
          ),
          if (link != null) ...[
            const SizedBox(height: 8),
            CupertinoButton(
              onPressed: _busy ? null : _unlink,
              child: Text(
                l10n.steamUnlink,
                style: const TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Состояние импорта внутри листа: подсказка для скрытого профиля.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.link});

  final SteamLink link;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hint = switch (link.status) {
      SteamLinkStatus.privateProfile => l10n.steamPrivateHint,
      SteamLinkStatus.notFound => l10n.steamNotFoundHint,
      SteamLinkStatus.pending => l10n.steamPendingHint,
      // Скрытый список worker отличает от пустого и ставит private_profile.
      SteamLinkStatus.ok when (link.wishlistCount ?? 0) == 0 =>
        l10n.steamEmptyHint,
      SteamLinkStatus.ok => l10n.steamOkHint,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (link.status == SteamLinkStatus.pending)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: CupertinoActivityIndicator(),
            )
          else
            _StatusIcon(link.status),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  steamStatusText(context, link),
                  style: AppText.title(context),
                ),
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: AppText.secondary(context).copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
