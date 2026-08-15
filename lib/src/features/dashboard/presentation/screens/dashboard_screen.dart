import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/attention_insight_card.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/dashboard_loading_skeleton.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/dashboard_metric_card.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/quick_actions_section.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/restaurant_pulse_card.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/revenue_summary_card.dart';

enum DashboardViewState { loaded, empty, partial, loading, error }

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.viewState = DashboardViewState.loaded,
    this.onTryAgain,
  });

  final DashboardViewState viewState;
  final VoidCallback? onTryAgain;

  bool get _hasData => viewState != DashboardViewState.empty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.space6xl,
          ),
          children: [
            if (viewState == DashboardViewState.loading)
              const DashboardLoadingSkeleton()
            else if (viewState == DashboardViewState.error)
              DashboardErrorCard(onTryAgain: onTryAgain ?? () {})
            else ...[
              RestaurantPulseCard(
                hasData: _hasData,
                onAddOrder: () => _openAddOrder(context),
                onAddExpense: () => _openAddExpense(context),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              RevenueSummaryCard(hasData: _hasData),
              const SizedBox(height: AppSpacing.spaceMd),
              _MetricsGrid(viewState: viewState),
              if (_hasData) ...[
                const SizedBox(height: AppSpacing.spaceLg),
                Text(
                  'Needs Your Attention',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                AttentionInsightCard(onAction: () => _openMenu(context)),
              ],
              const SizedBox(height: AppSpacing.spaceLg),
              QuickActionsSection(
                onAddOrder: () => _openAddOrder(context),
                onAddExpense: () => _openAddExpense(context),
                onRecordWastage: () => _openWastage(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openAddOrder(BuildContext context) {
    context.pushNamed(AppRoute.addOrder.name);
  }

  void _openAddExpense(BuildContext context) {
    context.pushNamed(AppRoute.addExpense.name);
  }

  void _openMenu(BuildContext context) {
    context.goNamed(AppRoute.menu.name);
  }

  void _openWastage(BuildContext context) {
    context.pushNamed(AppRoute.recordWastage.name);
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.viewState});

  final DashboardViewState viewState;

  @override
  Widget build(BuildContext context) {
    final isEmpty = viewState == DashboardViewState.empty;
    final isPartial = viewState == DashboardViewState.partial;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Orders',
                  value: isEmpty ? '—' : '142',
                  comparison: isEmpty ? null : '↑ 7.2%',
                  status: MetricStatus.positive,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.payments_outlined,
                  title: 'Avg. Order',
                  value: isEmpty ? '—' : 'Rs 201',
                  comparison: isEmpty ? null : '↑ 4.8%',
                  status: MetricStatus.positive,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.trending_up_rounded,
                  title: 'Est. Profit',
                  value: isEmpty
                      ? '—'
                      : isPartial
                      ? 'Not enough data'
                      : 'Rs 7,650',
                  comparison: isEmpty || isPartial ? null : '↓ 2.1%',
                  subtitle: isPartial ? 'Add Expenses' : null,
                  status: MetricStatus.negative,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.restaurant_outlined,
                  title: 'Food Cost',
                  value: isEmpty || isPartial ? '—' : '28.4%',
                  subtitle: isEmpty || isPartial ? null : 'Target < 30%',
                  status: MetricStatus.warning,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
