import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/push/push_providers.dart';
import '../../../core/push/push_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/l10n.dart';
import 'settings_providers.dart';
import '../../../core/widgets/app_controls.dart';

/// Раздел «Уведомления»: разрешение на push, выключатель уведомлений
/// о ценах и тихие часы (правило 11).
class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final push = ref.watch(pushServiceProvider);
    final settings = ref.watch(currentProfileProvider).value?.settings;

    return AppGroupedSection(
      header: Text(l10n.settingsNotifications.toUpperCase()),
      footer: Text(l10n.quietHoursHint),
      children: [
        ListenableBuilder(
          listenable: push,
          builder: (context, _) => _PushStatusTile(status: push.status),
        ),
        AppListTile(
          leading: const Icon(CupertinoIcons.bell),
          title: Text(l10n.priceAlertsTitle),
          subtitle: Text(l10n.priceAlertsSubtitle),
          trailing: CupertinoSwitch(
            value: settings?.notificationsEnabled ?? true,
            activeTrackColor: AppColors.accent.resolveFrom(context),
            onChanged: settings == null
                ? null
                : (on) async {
                    if (on) {
                      await ref.read(pushServiceProvider).requestPermission();
                    }
                    if (!context.mounted) return;
                    await _save(
                      context,
                      ref,
                      (s) => s.copyWith(notificationsEnabled: on),
                    );
                  },
          ),
        ),
        AppListTile(
          leading: const Icon(CupertinoIcons.moon),
          title: Text(l10n.quietHoursTitle),
          subtitle: Text(switch (settings?.quietHours) {
            final q? => l10n.quietHoursRange('${q.start}', '${q.end}'),
            null => l10n.quietHoursOff,
          }),
          trailing: AppListTile.chevron,
          onTap: settings == null
              ? null
              : () => GlassModalSheet.show<void>(
                  context: context,
                  halfSize: 0.62,
                  builder: (_) =>
                      _QuietHoursSheet(initial: settings.quietHours),
                ),
        ),
      ],
    );
  }
}

/// Сохраняет настройки на сервере целиком (PUT /me/settings).
Future<void> _save(
  BuildContext context,
  WidgetRef ref,
  UserSettings Function(UserSettings s) change,
) async {
  final profile = ref.read(currentProfileProvider).value;
  if (profile == null) return;
  try {
    await ref
        .read(settingsRepositoryProvider)
        .saveSettings(change(profile.settings));
    ref.invalidate(currentProfileProvider);
  } on Object {
    if (context.mounted) {
      GlassToast.show(
        context,
        message: context.l10n.settingsSaveFailed,
        type: GlassToastType.error,
        position: GlassToastPosition.top,
      );
    }
  }
}

class _PushStatusTile extends ConsumerWidget {
  const _PushStatusTile({required this.status});

  final PushStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (text, icon, color) = switch (status) {
      PushStatus.ready => (
        l10n.pushReady,
        CupertinoIcons.checkmark_seal_fill,
        AppColors.discount,
      ),
      PushStatus.notAsked => (
        l10n.pushNotAsked,
        CupertinoIcons.hand_raised,
        AppColors.accent,
      ),
      PushStatus.denied => (
        l10n.pushDenied,
        CupertinoIcons.bell_slash,
        AppColors.textSecondary,
      ),
      PushStatus.unavailable => (
        l10n.pushUnavailable,
        CupertinoIcons.bell_slash,
        AppColors.textSecondary,
      ),
      PushStatus.starting => (
        l10n.pushStarting,
        CupertinoIcons.ellipsis,
        AppColors.textSecondary,
      ),
    };
    return AppListTile(
      leading: const Icon(CupertinoIcons.app_badge),
      title: Text(l10n.pushStatusTitle),
      subtitle: Text(text),
      trailing: Icon(icon, color: color.resolveFrom(context)),
      onTap: status == PushStatus.notAsked
          ? () => ref.read(pushServiceProvider).requestPermission()
          : null,
    );
  }
}

/// Тихие часы: выключатель и время «с» / «до» в местном времени.
class _QuietHoursSheet extends ConsumerStatefulWidget {
  const _QuietHoursSheet({required this.initial});

  final QuietHours? initial;

  @override
  ConsumerState<_QuietHoursSheet> createState() => _QuietHoursSheetState();
}

class _QuietHoursSheetState extends ConsumerState<_QuietHoursSheet> {
  late bool _enabled = widget.initial != null;
  late ClockTime _start = widget.initial?.start ?? const ClockTime(23, 0);
  late ClockTime _end = widget.initial?.end ?? const ClockTime(8, 0);
  bool _saving = false;

  Future<void> _submit() async {
    setState(() => _saving = true);
    final quiet = _enabled ? QuietHours(start: _start, end: _end) : null;
    await _save(context, ref, (s) => s.copyWith(quietHours: quiet));
    if (mounted) Navigator.of(context).pop();
  }

  Widget _picker(
    String label,
    ClockTime value,
    ValueChanged<ClockTime> onChanged,
  ) => Expanded(
    child: Column(
      children: [
        Text(label, style: AppText.sectionHeader(context)),
        SizedBox(
          height: 130,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            minuteInterval: 5,
            initialDateTime: DateTime(
              2000,
              1,
              1,
              value.hour,
              value.minute - value.minute % 5,
            ),
            onDateTimeChanged: (d) => onChanged(ClockTime(d.hour, d.minute)),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onAccent = CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? const Color(0xFF06121C)
        : CupertinoColors.white;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quietHoursTitle,
            style: AppText.largeTitle(context).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quietHoursEnable,
                  style: AppText.body(context),
                ),
              ),
              CupertinoSwitch(
                value: _enabled,
                activeTrackColor: AppColors.accent.resolveFrom(context),
                onChanged: (v) => setState(() => _enabled = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: _enabled ? 1 : 0.35,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_enabled,
              child: Row(
                children: [
                  _picker(l10n.quietHoursFrom, _start, (t) => _start = t),
                  const SizedBox(width: 12),
                  _picker(l10n.quietHoursTo, _end, (t) => _end = t),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: CupertinoButton.filled(
              onPressed: _saving ? null : _submit,
              borderRadius: BorderRadius.circular(25),
              child: _saving
                  ? CupertinoActivityIndicator(color: onAccent)
                  : Text(
                      l10n.save,
                      style: AppText.title(context).copyWith(color: onAccent),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
