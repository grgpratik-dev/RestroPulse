import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_filter_sheet.dart';
import '../widgets/expense_history_widgets.dart';
import 'expense_details_screen.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({
    this.initialExpenses,
    this.initialCategory,
    super.key,
  });

  final List<Expense>? initialExpenses;
  final String? initialCategory;

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  static final DateTime _latestRecordedDate = DateTime(2026, 8, 16);

  late final List<Expense> _expenses = [
    ...(widget.initialExpenses ?? ExpensesMockData.expenses),
  ];
  ExpensePeriod _selectedPeriod = ExpensePeriod.month;
  late ExpenseFilterSelection _filters;

  DateTimeRange get _range => _rangeFor(_selectedPeriod);

  @override
  void initState() {
    super.initState();
    final initialCategory = widget.initialCategory;
    _filters = ExpenseFilterSelection(
      category: ExpenseCategories.defaults.contains(initialCategory)
          ? initialCategory
          : null,
    );
  }

  List<Expense> get _visibleExpenses {
    final inclusiveEnd = _range.end.add(const Duration(days: 1));
    final values = _expenses.where((expense) {
      final inRange =
          !expense.date.isBefore(_range.start) &&
          expense.date.isBefore(inclusiveEnd);
      final categoryMatches =
          _filters.category == null || expense.category == _filters.category;
      final typeMatches =
          _filters.type == null || expense.type == _filters.type;
      return inRange && categoryMatches && typeMatches;
    }).toList();

    switch (_filters.sort) {
      case ExpenseSort.newest:
        values.sort((a, b) => b.date.compareTo(a.date));
      case ExpenseSort.oldest:
        values.sort((a, b) => a.date.compareTo(b.date));
      case ExpenseSort.highest:
        values.sort((a, b) => b.amount.compareTo(a.amount));
      case ExpenseSort.lowest:
        values.sort((a, b) => a.amount.compareTo(b.amount));
    }
    return values;
  }

  List<DateTime> get _groupDates {
    final dates = _visibleExpenses
        .map(
          (expense) =>
              DateTime(expense.date.year, expense.date.month, expense.date.day),
        )
        .toSet()
        .toList();
    final oldestFirst = _filters.sort == ExpenseSort.oldest;
    dates.sort((a, b) => oldestFirst ? a.compareTo(b) : b.compareTo(a));
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _visibleExpenses;
    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense History'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.spaceXl,
          ),
          children: [
            AppPeriodSelector<ExpensePeriod>(
              selected: _selectedPeriod,
              options: const [
                ExpensePeriod.week,
                ExpensePeriod.month,
                ExpensePeriod.quarter,
                ExpensePeriod.sixMonths,
                ExpensePeriod.year,
              ],
              labelOf: (period) => period.label,
              descriptionOf: (period) => _formatRange(_rangeFor(period)),
              onChanged: (period) {
                setState(() => _selectedPeriod = period);
              },
              title: 'Expense history period',
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            ExpenseHistorySummary(
              rangeLabel: _rangeLabel,
              total: total,
              transactions: expenses.length,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                key: const ValueKey('expense-history-filter'),
                onPressed: _showFilters,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: _filters.isActive
                      ? AppColors.expenseSurface
                      : null,
                ),
                icon: SvgPicture.asset(
                  _filters.isActive
                      ? AppIcons.filter_alt_rounded
                      : AppIcons.filter_alt_outlined,
                  width: 18,
                  height: 18,
                ),
                label: const Text('Filter'),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            if (expenses.isEmpty)
              ExpenseHistoryEmptyState(onChangeFilters: _showFilters)
            else
              for (var index = 0; index < _groupDates.length; index++) ...[
                ExpenseHistoryGroup(
                  date: _groupDates[index],
                  expenses: _expensesForDate(expenses, _groupDates[index]),
                  onExpenseTap: _openExpense,
                ),
                if (index != _groupDates.length - 1)
                  const SizedBox(height: AppSpacing.spaceMd),
              ],
          ],
        ),
      ),
    );
  }

  String get _rangeLabel => _formatRange(_range);

  List<Expense> _expensesForDate(List<Expense> values, DateTime date) {
    final results = values.where((expense) {
      return expense.date.year == date.year &&
          expense.date.month == date.month &&
          expense.date.day == date.day;
    }).toList();
    if (_filters.sort == ExpenseSort.highest) {
      results.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (_filters.sort == ExpenseSort.lowest) {
      results.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (_filters.sort == ExpenseSort.oldest) {
      results.sort((a, b) => a.date.compareTo(b.date));
    } else {
      results.sort((a, b) => b.date.compareTo(a.date));
    }
    return results;
  }

  DateTimeRange _rangeFor(ExpensePeriod period) {
    final end = _latestRecordedDate;
    final start = switch (period) {
      ExpensePeriod.week => end.subtract(const Duration(days: 6)),
      ExpensePeriod.month => DateTime(end.year, end.month),
      ExpensePeriod.quarter => DateTime(end.year, end.month - 2),
      ExpensePeriod.sixMonths => DateTime(end.year, end.month - 5),
      ExpensePeriod.year => DateTime(end.year - 1, end.month + 1),
    };
    return DateTimeRange(start: start, end: end);
  }

  String _formatRange(DateTimeRange range) {
    if (range.start.year == range.end.year) {
      return '${DateFormat('MMM d').format(range.start)} – '
          '${DateFormat('MMM d, y').format(range.end)}';
    }
    return '${DateFormat('MMM d, y').format(range.start)} – '
        '${DateFormat('MMM d, y').format(range.end)}';
  }

  Future<void> _showFilters() async {
    final selected = await showExpenseFilterSheet(
      context: context,
      initial: _filters,
    );
    if (!mounted || selected == null) return;
    setState(() => _filters = selected);
  }

  Future<void> _openExpense(Expense expense) async {
    final result = await context.pushNamed<ExpenseDetailsResult>(
      AppRoute.expenseDetails.name,
      extra: expense,
    );
    if (!mounted || result == null) return;
    setState(() {
      final index = _expenses.indexWhere((entry) => entry.id == expense.id);
      if (result.deleted) {
        if (index >= 0) _expenses.removeAt(index);
      } else if (index >= 0 && result.expense != null) {
        _expenses[index] = result.expense!;
      }
    });
  }
}
