import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/report_data.dart';
import '../widgets/performance_overview_card.dart';
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
            AppSpacing.space6xl,
          ),
          children: [
            _ReportsHeader(onExport: _showExportSheet),
            const SizedBox(height: AppSpacing.spaceMd),
            _PeriodSelector(
              selected: _period,
              onChanged: (value) => setState(() => _period = value),
            ),
            const SizedBox(height: 6),
            Text(
              'Compared with previous period',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
        onAddExpense: () => context.goNamed(AppRoute.expenses.name),
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
        const SizedBox(height: AppSpacing.spaceMd),
        ProfitabilityReportCard(report: report, hasExpenseData: hasExpenses),
        const SizedBox(height: AppSpacing.spaceMd),
        FoodCostReportCard(report: report),
        const SizedBox(height: AppSpacing.spaceMd),
        if (hasExpenses) ...[
          ExpenseBreakdownCard(
            onViewExpenses: () => context.goNamed(AppRoute.expenses.name),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
        ],
        SalesChannelReportCard(
          onViewSales: () => context.goNamed(AppRoute.sales.name),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        MenuPerformanceReportCard(
          onViewMenu: () => context.goNamed(AppRoute.menu.name),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        WastageReportCard(
          onViewWastage: () => context.pushNamed(AppRoute.wastage.name),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        OrderBehaviourCard(orderCount: report.orders),
        const SizedBox(height: AppSpacing.spaceXl),
        const BusinessInsightsSection(),
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
                '${_period.exportLabel} · August 2026',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              _ExportOption(
                icon: Icons.picture_as_pdf_outlined,
                title: 'PDF',
                subtitle: 'Easy to share and print',
                onTap: () => Navigator.pop(context, 'PDF'),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              _ExportOption(
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

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader({required this.onExport});

  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Understand what changed and why.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.spaceSm),
        OutlinedButton.icon(
          onPressed: onExport,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 42),
            padding: const EdgeInsets.symmetric(horizontal: 13),
          ),
          icon: const Icon(Icons.ios_share_rounded, size: 18),
          label: const Text('Export'),
        ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onChanged});

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ReportPeriod>(
        segments: ReportPeriod.values
            .map(
              (period) =>
                  ButtonSegment(value: period, label: Text(period.label)),
            )
            .toList(),
        selected: {selected},
        showSelectedIcon: false,
        onSelectionChanged: (values) => onChanged(values.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : Colors.white,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF0FBF7),
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
