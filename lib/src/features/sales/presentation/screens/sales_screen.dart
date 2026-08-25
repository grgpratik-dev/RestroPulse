import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_add_floating_action_button.dart';
import 'package:restropulse/src/core/widgets/app_feature_header.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/recent_orders_section.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_channel_card.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_entry_type_sheet.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_loading_skeleton.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/today_sales_summary_card.dart';

enum SalesViewState { loaded, empty, partial, loading, error }

class SalesScreen extends StatelessWidget {
  const SalesScreen({
    super.key,
    this.viewState = SalesViewState.loaded,
    this.onTryAgain,
  });

  final SalesViewState viewState;
  final VoidCallback? onTryAgain;

  static const _todayRevenue = 28450;
  static const _todayRevenueChange = 12.4;
  static const _todayOrders = 42;
  static const _todayAverageOrder = 677;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppAddFloatingActionButton(
        onPressed: () => _showEntryOptions(context),
        tooltip: 'Record sales',
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
              const AppFeatureHeader(
                title: 'Sales',
                subtitle: 'Today’s sales and recent orders.',
                contextLabel: 'Today · Aug 16',
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              if (viewState == SalesViewState.loading)
                const SalesLoadingSkeleton()
              else if (viewState == SalesViewState.error)
                SalesErrorCard(onTryAgain: onTryAgain ?? () {})
              else if (viewState == SalesViewState.empty)
                SalesOrdersEmptyState(
                  onRecordSales: () => _showEntryOptions(context),
                )
              else ...[
                const TodaySalesSummaryCard(
                  revenue: _todayRevenue,
                  change: _todayRevenueChange,
                  orders: _todayOrders,
                  averageOrder: _todayAverageOrder,
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                if (viewState == SalesViewState.partial)
                  SalesChannelEmptyCard(
                    onUpdateSales: () => _openAddOrder(context),
                  )
                else
                  const SalesChannelCard(totalRevenue: _todayRevenue),
                const SizedBox(height: AppSpacing.spaceLg),
                RecentOrdersSection(
                  orders: SalesMockData.todayOrders,
                  onOrderTap: (order) => _openOrderDetails(context, order),
                  onViewHistory: () => _openSalesHistory(context),
                ),
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

  void _openAddOrder(BuildContext context) {
    context.pushNamed(AppRoute.addOrder.name);
  }

  Future<void> _showEntryOptions(BuildContext context) async {
    final type = await showSalesEntryTypeSheet(context);
    if (!context.mounted || type == null) return;
    switch (type) {
      case SalesEntryType.singleOrder:
        _openAddOrder(context);
      case SalesEntryType.batchEntry:
        _openBatchEntry(context);
    }
  }

  void _openBatchEntry(BuildContext context) {
    context.pushNamed(AppRoute.batchEntry.name);
  }

  void _openOrderDetails(BuildContext context, SalesOrder order) {
    context.pushNamed(AppRoute.orderDetails.name, extra: order);
  }

  void _openSalesHistory(BuildContext context) {
    context.pushNamed(AppRoute.salesHistory.name);
  }
}
