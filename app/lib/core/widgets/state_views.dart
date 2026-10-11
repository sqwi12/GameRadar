import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../network/app_exception.dart';
import '../theme/app_theme.dart';
import 'l10n.dart';

/// Состояние загрузки.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CupertinoActivityIndicator(radius: 14));
}

/// Ошибка с кнопкой «Повторить».
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final offline = AppException.from(error) is NetworkException;
    return MessageView(
      icon: offline
          ? CupertinoIcons.wifi_slash
          : CupertinoIcons.exclamationmark_triangle,
      message: describeError(context.l10n, error),
      action: GlassButton.custom(
        onTap: onRetry,
        height: 44,
        label: context.l10n.retry,
        shape: const LiquidRoundedSuperellipse(borderRadius: 22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(context.l10n.retry, style: AppText.title(context)),
        ),
      ),
    );
  }
}

/// Пустое состояние или заглушка: иконка в стеклянном круге и текст.
class MessageView extends StatelessWidget {
  const MessageView({
    required this.icon,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassCard(
            shape: const LiquidOval(),
            padding: const EdgeInsets.all(24),
            child: Icon(
              icon,
              size: 40,
              color: AppColors.accent.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.secondary(context).copyWith(fontSize: 16),
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    ),
  );
}

/// «Обновлено N мин назад» — время последнего обновления (правило 10).
/// Перерисовывается раз в минуту сам.
class LastUpdatedLabel extends StatefulWidget {
  const LastUpdatedLabel({required this.fetchedAt, super.key});

  final DateTime fetchedAt;

  @override
  State<LastUpdatedLabel> createState() => _LastUpdatedLabelState();
}

class _LastUpdatedLabelState extends State<LastUpdatedLabel> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final minutes = DateTime.now().difference(widget.fetchedAt).inMinutes;
    final text = switch (minutes) {
      < 1 => l10n.updatedJustNow,
      < 60 => l10n.updatedMinutesAgo(minutes),
      _ => l10n.updatedAt(
        DateFormat.MMMd(Localizations.localeOf(context).toLanguageTag())
            .add_Hm()
            .format(widget.fetchedAt.toLocal()),
      ),
    };
    return Text(text, style: AppText.secondary(context).copyWith(fontSize: 12));
  }
}
