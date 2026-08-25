import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_add_floating_action_button.dart';
import '../../../../core/widgets/app_feature_header.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_breakdown.dart';
import '../widgets/expense_states.dart';
import '../widgets/expense_summary_card.dart';
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
  double _totalAdjustment = 0;
  int _transactionAdjustment = 0;

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

    final monthlyBase = ExpensesMockData.snapshot(ExpensePeriod.month);
    final monthlyCategories = ExpensesMockData.categorySummaries(
      ExpensePeriod.month,
    );
    final monthlySnapshot = ExpensePeriodSnapshot(
      total: monthlyBase.total + _totalAdjustment,
      change: monthlyBase.change,
      transactions: monthlyBase.transactions + _transactionAdjustment,
      averageDaily: monthlyBase.averageDaily,
      comparisonLabel: monthlyBase.comparisonLabel,
      trend: monthlyBase.trend,
    );
    return Column(
      children: [
        ExpenseSummaryCard(
          snapshot: monthlySnapshot,
          largestCategory: monthlyCategories.first,
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        ExpenseCategoryBreakdown(
          categories: monthlyCategories,
          onCategoryTap: (category) =>
              _openExpenseHistory(category: category.name),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        RecentExpensesList(
          expenses: _expenses.take(5).toList(),
          onExpenseTap: _openExpense,
          onViewHistory: () => _openExpenseHistory(),
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

  void _openExpenseHistory({String? category}) {
    context.pushNamed(
      AppRoute.expenseHistory.name,
      queryParameters: category == null ? const {} : {'category': category},
      extra: [..._expenses],
    );
  }
}
