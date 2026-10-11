import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../cache/cached_resource.dart';
import '../cache/resource_state.dart';
import '../theme/app_theme.dart';
import 'glass_screen.dart';
import 'l10n.dart';
import 'state_views.dart';

/// Прокручиваемое тело экрана с кэшем (правило 10):
/// - пока данных нет — загрузка, ошибка с «Повторить» или пустое состояние;
/// - с данными — «Обновлено N мин назад», pull-to-refresh не чаще раза
///   в минуту и пометка «Показаны сохранённые данные», если сеть недоступна.
class ResourceScrollView<T> extends StatelessWidget {
  const ResourceScrollView({
    required this.view,
    required this.onRetry,
    required this.onRefresh,
    required this.slivers,
    required this.isEmpty,
    required this.empty,
    this.header = const [],
    this.insideTabs = true,
    this.controller,
    super.key,
  });

  final ResourceView<T> view;
  final VoidCallback onRetry;
  final Future<RefreshResult> Function() onRefresh;

  /// Содержимое для готовых данных.
  final List<Widget> Function(BuildContext context, T data) slivers;
  final bool Function(T data) isEmpty;
  final Widget empty;

  /// Всегда видимые элементы над данными (фильтры, поиск).
  final List<Widget> header;
  final bool insideTabs;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final padding = GlassScreen.contentPadding(context, insideTabs: insideTabs);
    final data = view.data;

    Widget fill(Widget child) => SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: padding.bottom),
        child: child,
      ),
    );

    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        GlassBarSpacer(height: padding.top),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            final result = await onRefresh();
            if (result == RefreshResult.throttled && context.mounted) {
              GlassToast.show(
                context,
                message: context.l10n.refreshTooOften,
                type: GlassToastType.info,
                position: GlassToastPosition.top,
                duration: const Duration(seconds: 2),
              );
            }
          },
        ),
        for (final h in header)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 12),
            sliver: SliverToBoxAdapter(child: h),
          ),
        if (data == null)
          if (view.isInitialLoading)
            fill(const LoadingView())
          else
            fill(ErrorView(error: view.error!, onRetry: onRetry))
        else ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding.left + 4,
              0,
              padding.right,
              10,
            ),
            sliver: SliverToBoxAdapter(child: _Status(view: view)),
          ),
          if (isEmpty(data))
            fill(empty)
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                0,
                padding.right,
                padding.bottom,
              ),
              sliver: SliverMainAxisGroup(slivers: slivers(context, data)),
            ),
        ],
      ],
    );
  }
}

/// «Обновлено N мин назад» и пометка о сохранённых данных при ошибке.
class _Status extends StatelessWidget {
  const _Status({required this.view});

  final ResourceView<Object?> view;

  @override
  Widget build(BuildContext context) {
    final style = AppText.secondary(context).copyWith(fontSize: 12);
    return Row(
      children: [
        LastUpdatedLabel(fetchedAt: view.cached!.fetchedAt),
        if (view.refreshing) ...[
          const SizedBox(width: 8),
          const CupertinoActivityIndicator(radius: 6),
        ],
        if (view.error != null) ...[
          const SizedBox(width: 8),
          Icon(CupertinoIcons.wifi_slash, size: 13, color: style.color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              context.l10n.showingCachedData,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

/// Список игр с отступами между карточками.
SliverList separatedList<T>({
  required List<T> items,
  required Widget Function(BuildContext context, T item, int index) builder,
}) => SliverList.separated(
  itemCount: items.length,
  itemBuilder: (context, i) => builder(context, items[i], i),
  separatorBuilder: (_, _) => const SizedBox(height: 10),
);

/// Подвал постраничного списка: загрузка следующей страницы или ошибка.
class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    required this.loading,
    required this.error,
    required this.onRetry,
    super.key,
  });

  final bool loading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Center(
      child: loading
          ? const CupertinoActivityIndicator()
          : error != null
          ? CupertinoButton(
              onPressed: onRetry,
              child: Text(describeError(context.l10n, error!)),
            )
          : const SizedBox.shrink(),
    ),
  );
}

/// Прозрачный отступ под стеклянную шапку. Закреплённый, как навигационная
/// панель iOS: только после такой шапки CupertinoSliverRefreshControl видит
/// свайп вниз (после обычного отступа pull-to-refresh не срабатывает).
class GlassBarSpacer extends StatelessWidget {
  const GlassBarSpacer({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) =>
      SliverPersistentHeader(pinned: true, delegate: _SpacerDelegate(height));
}

class _SpacerDelegate extends SliverPersistentHeaderDelegate {
  const _SpacerDelegate(this.height);

  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => const SizedBox.expand();

  @override
  bool shouldRebuild(_SpacerDelegate old) => old.height != height;
}
