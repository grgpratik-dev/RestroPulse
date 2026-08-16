import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_feature_header.dart';
import '../../../../core/widgets/app_section_heading.dart';
import '../../domain/models/report_data.dart';
import '../widgets/performance_overview_card.dart';
import '../widgets/report_controls.dart';
import '../widgets/report_sections.dart';
import '../widgets/report_states.dart';
import '../widgets/revenue_expenses_chart.dart';

enum ReportsViewState { loaded, partial, empty, loading, error }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({
    this.viewState = ReportsViewState.loaded,
    this.onTryAgain,
    super.key,
  });

  final ReportsViewState viewState;
  final VoidCallback? onTryAgain;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _period = ReportPeriod.month;

  ReportSnapshot get _report => ReportsMockData.forPeriod(_period);

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
            AppSpacing.space6xl + AppSpacing.space3xl,
          ),
          children: [
            AppFeatureHeader(
              title: 'Reports',
              subtitle: 'Understand what changed and why.',
              trailing: OutlinedButton.icon(
                onPressed: _showExportSheet,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                ),
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                label: const Text('Export'),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            ReportPeriodSelector(
              selected: _period,
              onChanged: (value) => setState(() => _period = value),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.viewState == ReportsViewState.loading) {
      return const ReportsLoadingSkeleton();
    }
    if (widget.viewState == ReportsViewState.error) {
      return ReportsErrorState(onRetry: widget.onTryAgain ?? () {});
    }
    if (widget.viewState == ReportsViewState.empty) {
      return ReportsEmptyState(
        onAddOrder: () => context.pushNamed(AppRoute.addOrder.name),
        onAddExpense: () => context.pushNamed(AppRoute.addExpense.name),
      );
    }

    final report = _report;
    final hasExpenses = widget.viewState != ReportsViewState.partial;
    return Column(
      children: [
        PerformanceOverviewCard(report: report, hasExpenseData: hasExpenses),
        if (hasExpenses) ...[
          const SizedBox(height: AppSpacing.spaceMd),
          RevenueExpensesChart(points: report.chartPoints),
        ],
        const SizedBox(height: AppSpacing.spaceXl),
        BusinessInsightsSection(
          report: report,
          onViewExpenses: () => context.goNamed(AppRoute.expenses.name),
          onViewMenu: () => context.goNamed(AppRoute.menu.name),
          onViewSales: () => context.goNamed(AppRoute.sales.name),
        ),
        const SizedBox(height: AppSpacing.spaceXl),
        const AppSectionHeading(
          title: 'Financial Breakdown',
          subtitle: 'Understand how revenue becomes estimated profit.',
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ProfitabilityReportCard(report: report, hasExpenseData: hasExpenses),
        const SizedBox(height: AppSpacing.spaceXl),
        const AppSectionHeading(
          title: 'Drivers & Impact',
          subtitle: 'The factors shaping restaurant performance.',
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        OperationalHighlightsCard(
          report: report,
          onViewSales: () => context.goNamed(AppRoute.sales.name),
          onViewMenu: () => context.goNamed(AppRoute.menu.name),
          onViewWastage: () => context.pushNamed(AppRoute.wastage.name),
        ),
      ],
    );
  }

  Future<void> _showExportSheet() async {
    final selection = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceLg,
            0,
            AppSpacing.spaceLg,
            AppSpacing.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Report',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${_period.exportLabel} · ${_period.dateLabel}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              ReportExportOption(
                icon: Icons.picture_as_pdf_outlined,
                title: 'PDF',
                subtitle: 'Easy to share and print',
                onTap: () => Navigator.pop(context, 'PDF'),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              ReportExportOption(
                icon: Icons.table_chart_outlined,
                title: 'CSV',
                subtitle: 'Open report data in a spreadsheet',
                onTap: () => Navigator.pop(context, 'CSV'),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || selection == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selection export is ready for integration.')),
    );
  }
}
