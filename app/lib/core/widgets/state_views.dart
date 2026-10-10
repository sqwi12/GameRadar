import 'dart:async';

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../network/app_exception.dart';
import 'l10n.dart';

/// Состояние загрузки.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

/// Ошибка с кнопкой «Повторить».
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final offline = AppException.from(error) is NetworkException;
    return _CenteredMessage(
      icon: offline ? Icons.cloud_off_rounded : Icons.error_outline_rounded,
      message: describeError(context.l10n, error),
      action: FilledButton.tonal(
        onPressed: onRetry,
        child: Text(context.l10n.retry),
      ),
    );
  }
}

/// Пустое состояние или заглушка.
class MessageView extends StatelessWidget {
  const MessageView({required this.icon, required this.message, super.key});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) =>
      _CenteredMessage(icon: icon, message: message);
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
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
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.outline,
      ),
    );
  }
}
