import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_add_floating_action_button.dart';
import '../../../../core/widgets/app_feature_header.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_breakdown.dart';
import '../widgets/expense_filter_sheet.dart';
import '../widgets/expense_states.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/expense_trend_card.dart';
import '../widgets/recent_expenses_list.dart';
import 'expense_details_screen.dart';

enum ExpensesViewState { loaded, noPeriodData, empty, loading, error }

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    this.viewState = ExpensesViewState.loaded,
    this.initialExpenses,
    this.onTryAgain,
    super.key,
  });

  final ExpensesViewState viewState;
  final List<Expense>? initialExpenses;
  final VoidCallback? onTryAgain;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late final List<Expense> _expenses = [
    ...(widget.initialExpenses ?? ExpensesMockData.expenses),
  ];
  static const _period = ExpensePeriod.month;
  ExpenseFilterSelection _filters = const ExpenseFilterSelection();
  double _totalAdjustment = 0;
  int _transactionAdjustment = 0;

  List<Expense> get _filteredExpenses {
    final result = _expenses.where((expense) {
      final categoryMatches =
          _filters.category == null || expense.category == _filters.category;
      final typeMatches =
          _filters.type == null || expense.type == _filters.type;
      return categoryMatches && typeMatches;
    }).toList();
    switch (_filters.sort) {
      case ExpenseSort.newest:
        result.sort((a, b) => b.date.compareTo(a.date));
      case ExpenseSort.oldest:
        result.sort((a, b) => a.date.compareTo(b.date));
      case ExpenseSort.highest:
        result.sort((a, b) => b.amount.compareTo(a.amount));
      case ExpenseSort.lowest:
        result.sort((a, b) => a.amount.compareTo(b.amount));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppAddFloatingActionButton(
        onPressed: _addExpense,
        tooltip: 'Add expense',
        heroTag: 'expenses-add-expense-fab',
      ),
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
            const AppFeatureHeader(
              title: 'Expenses',
              subtitle: "Track where your restaurant's money goes.",
              contextLabel: 'This Month · August 2026',
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.viewState == ExpensesViewState.loading) {
      return const ExpensesLoadingSkeleton();
    }
    if (widget.viewState == ExpensesViewState.error) {
      return ExpensesErrorState(onRetry: widget.onTryAgain ?? () {});
    }
    if (widget.viewState == ExpensesViewState.empty || _expenses.isEmpty) {
      return ExpensesEmptyState(onAddExpense: _addExpense);
    }
    if (widget.viewState == ExpensesViewState.noPeriodData) {
      return ExpensesNoPeriodState(onAddExpense: _addExpense);
    }

    final baseSnapshot = ExpensesMockData.snapshot(_period);
    final categories = ExpensesMockData.categorySummaries(_period);
    final snapshot = ExpensePeriodSnapshot(
      total: baseSnapshot.total + _totalAdjustment,
      change: baseSnapshot.change,
      transactions: baseSnapshot.transactions + _transactionAdjustment,
      averageDaily: baseSnapshot.averageDaily,
      comparisonLabel: baseSnapshot.comparisonLabel,
      trend: baseSnapshot.trend,
    );
    return Column(
      children: [
        ExpenseSummaryCard(
          snapshot: snapshot,
          largestCategory: categories.first,
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        ExpenseCategoryBreakdown(
          categories: categories,
          onCategoryTap: (category) => context.pushNamed(
            AppRoute.expenseCategoryDetails.name,
            extra: ExpenseCategoryDetailsData(
              category: category,
              period: _period,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        Container(
          padding: const EdgeInsets.all(AppSpacing.spaceSm),
          decoration: BoxDecoration(
            color: AppColors.expenseSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.insights_outlined,
                color: AppColors.expenseForeground,
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  ExpensesMockData.categoryInsight(_period),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        ExpenseTrendCard(period: _period, points: snapshot.trend),
        const SizedBox(height: AppSpacing.spaceLg),
        RecentExpensesList(
          expenses: _filteredExpenses,
          onExpenseTap: _openExpense,
          onFilter: _showFilters,
          hasActiveFilter: _filters.isActive,
        ),
      ],
    );
  }

  Future<void> _addExpense() async {
    final expense = await context.pushNamed<Expense>(AppRoute.addExpense.name);
    if (!mounted || expense == null) return;
    setState(() {
      _expenses.insert(0, expense);
      _totalAdjustment += expense.amount;
      _transactionAdjustment += 1;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Expense added')));
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
        if (index >= 0) {
          _totalAdjustment -= _expenses[index].amount;
          _transactionAdjustment -= 1;
          _expenses.removeAt(index);
        }
      } else if (index >= 0 && result.expense != null) {
        _totalAdjustment += result.expense!.amount - _expenses[index].amount;
        _expenses[index] = result.expense!;
      }
    });
    if (result.deleted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Expense deleted')));
    }
  }

  Future<void> _showFilters() async {
    final selected = await showExpenseFilterSheet(
      context: context,
      initial: _filters,
    );
    if (!mounted || selected == null) return;
    setState(() => _filters = selected);
  }
}
