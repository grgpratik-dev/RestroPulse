import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_add_floating_action_button.dart';
import 'package:restropulse/src/core/widgets/app_feature_header.dart';
import 'package:restropulse/src/core/widgets/app_period_selector.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_channel_card.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_entry_type_sheet.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_loading_skeleton.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_card.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_data.dart';
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
  SalesTrendPeriod _analysisPeriod = SalesTrendPeriod.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppAddFloatingActionButton(
        onPressed: _showEntryOptions,
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
                subtitle: 'Track orders and sales performance.',
                contextLabel: 'Today · Aug 16',
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              if (widget.viewState == SalesViewState.loading)
                const SalesLoadingSkeleton()
              else if (widget.viewState == SalesViewState.error)
                SalesErrorCard(onTryAgain: widget.onTryAgain ?? () {})
              else if (widget.viewState == SalesViewState.empty)
                SalesOrdersEmptyState(onRecordSales: _showEntryOptions)
              else ...[
                const TodaySalesSummaryCard(),
                const SizedBox(height: AppSpacing.spaceLg),
                AppPeriodSelector<SalesTrendPeriod>(
                  selected: _analysisPeriod,
                  options: SalesTrendPeriod.values,
                  labelOf: (period) => period.label,
                  descriptionOf: (period) => period.dateLabel,
                  title: 'Sales analysis period',
                  onChanged: (period) =>
                      setState(() => _analysisPeriod = period),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                if (widget.viewState == SalesViewState.partial)
                  SalesChannelEmptyCard(onUpdateSales: _openAddOrder)
                else
                  SalesChannelCard(period: _analysisPeriod),
                const SizedBox(height: AppSpacing.spaceMd),
                SalesTrendCard(period: _analysisPeriod),
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

  Future<void> _showEntryOptions() async {
    final type = await showSalesEntryTypeSheet(context);
    if (!mounted || type == null) return;
    switch (type) {
      case SalesEntryType.singleOrder:
        _openAddOrder();
      case SalesEntryType.batchEntry:
        _openBatchEntry();
    }
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
