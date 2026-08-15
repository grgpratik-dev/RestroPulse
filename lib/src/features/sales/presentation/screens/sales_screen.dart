import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_add_floating_action_button.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_channel_card.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_loading_skeleton.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_card.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/today_orders_section.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/today_sales_summary_card.dart';

enum SalesViewState { loaded, empty, partial, loading, error }

class SalesScreen extends StatefulWidget {
  const SalesScreen({
    super.key,
    this.viewState = SalesViewState.loaded,
    this.onTryAgain,
  });

  final SalesViewState viewState;
  final VoidCallback? onTryAgain;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  OrderChannel? _selectedChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppAddFloatingActionButton(
        onPressed: _openAddOrder,
        tooltip: 'Add order',
        heroTag: 'sales-add-order-fab',
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spaceMd,
              AppSpacing.spaceXs,
              AppSpacing.spaceMd,
              AppSpacing.space6xl,
            ),
            children: [
              const _SalesHeader(),
              const SizedBox(height: AppSpacing.spaceMd),
              if (widget.viewState == SalesViewState.loading)
                const SalesLoadingSkeleton()
              else if (widget.viewState == SalesViewState.error)
                SalesErrorCard(onTryAgain: widget.onTryAgain ?? () {})
              else if (widget.viewState == SalesViewState.empty)
                SalesOrdersEmptyState(
                  onAddOrder: _openAddOrder,
                  onBatchEntry: _openBatchEntry,
                )
              else ...[
                const TodaySalesSummaryCard(),
                const SizedBox(height: AppSpacing.spaceSm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _openBatchEntry,
                    icon: const Icon(Icons.playlist_add_rounded, size: 19),
                    label: const Text('Batch Entry'),
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                const SalesQuickMetrics(),
                const SizedBox(height: AppSpacing.spaceLg),
                TodayOrdersSection(
                  orders: SalesMockData.todayOrders,
                  selectedChannel: _selectedChannel,
                  onChannelSelected: (channel) {
                    setState(() => _selectedChannel = channel);
                  },
                  onOrderTap: _openOrderDetails,
                  onViewHistory: _openSalesHistory,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                const SalesTrendCard(),
                const SizedBox(height: AppSpacing.spaceMd),
                if (widget.viewState == SalesViewState.partial)
                  SalesChannelEmptyCard(onUpdateSales: _openAddOrder)
                else
                  const SalesChannelCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    return Future<void>.delayed(const Duration(milliseconds: 500));
  }

  void _openAddOrder() {
    context.pushNamed(AppRoute.addOrder.name);
  }

  void _openBatchEntry() {
    context.pushNamed(AppRoute.batchEntry.name);
  }

  void _openOrderDetails(SalesOrder order) {
    context.pushNamed(AppRoute.orderDetails.name, extra: order);
  }

  void _openSalesHistory() {
    context.pushNamed(AppRoute.salesHistory.name);
  }
}

class _SalesHeader extends StatelessWidget {
  const _SalesHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          'Track orders and sales performance.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        const Row(
          children: [
            Icon(Icons.today_outlined, size: 17, color: AppColors.primary),
            SizedBox(width: AppSpacing.spaceXs),
            Text(
              'Today · Aug 16',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
