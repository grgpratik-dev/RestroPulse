import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_filter_sheet.dart';
import '../widgets/expense_history_widgets.dart';
import 'expense_details_screen.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({this.initialExpenses, super.key});

  final List<Expense>? initialExpenses;

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  static final DateTime _latestRecordedDate = DateTime(2026, 8, 16);

  late final List<Expense> _expenses = [
    ...(widget.initialExpenses ?? ExpensesMockData.expenses),
  ];
  late DateTimeRange _range = DateTimeRange(
    start: DateTime(2026, 8),
    end: _latestRecordedDate,
  );
  ExpenseFilterSelection _filters = const ExpenseFilterSelection();

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
            ExpenseHistorySummary(
              rangeLabel: _rangeLabel,
              total: total,
              transactions: expenses.length,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('expense-history-date-range'),
                    onPressed: _chooseDateRange,
                    icon: SvgPicture.asset(
                      AppIcons.date_range_outlined,
                      width: 18,
                      height: 18,
                    ),
                    label: Text(_compactRangeLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                OutlinedButton.icon(
                  key: const ValueKey('expense-history-filter'),
                  onPressed: _showFilters,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
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
              ],
            ),
            const SizedBox(height: AppSpacing.spaceLg),
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
                  const SizedBox(height: AppSpacing.spaceLg),
              ],
          ],
        ),
      ),
    );
  }

  String get _rangeLabel {
    if (_range.start.year == _range.end.year &&
        _range.start.month == _range.end.month) {
      return '${DateFormat('MMMM yyyy').format(_range.start)} · '
          '${DateFormat('MMM d').format(_range.start)}–${DateFormat('d').format(_range.end)}';
    }
    return '${DateFormat('MMM d, yyyy').format(_range.start)}–'
        '${DateFormat('MMM d, yyyy').format(_range.end)}';
  }

  String get _compactRangeLabel =>
      '${DateFormat('MMM d').format(_range.start)}–${DateFormat('MMM d').format(_range.end)}';

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

  Future<void> _chooseDateRange() async {
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2020),
      lastDate: _latestRecordedDate,
      helpText: 'Choose expense date range',
    );
    if (!mounted || selected == null) return;
    setState(() => _range = selected);
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
