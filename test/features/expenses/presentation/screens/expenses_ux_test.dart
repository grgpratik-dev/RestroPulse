import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/expenses/domain/models/expense.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_category_details_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/widgets/expense_summary_card.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester, Widget home) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: home));
  }

  testWidgets('expenses stays focused on the current month', (tester) async {
    await pumpScreen(tester, const ExpensesScreen());

    expect(find.text('Rs 210,000'), findsWidgets);
    expect(
      find.text('Ingredient spending is 14% higher than the previous month.'),
      findsOneWidget,
    );
    expect(find.text('This Month · August 2026'), findsOneWidget);
    expect(find.text('1W'), findsNothing);
    expect(find.text('1M'), findsNothing);
    expect(find.text('3M'), findsNothing);
      final summaryAmount = find.descendant(
        of: find.byType(ExpenseSummaryCard),
        matching: find.text('Rs 478,300'),
    );
    expect(summaryAmount, findsOneWidget);
    expect(tester.widget<Text>(summaryAmount).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expense details show only the date collected by the form', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      ExpenseDetailsScreen(expense: ExpensesMockData.expenses.first),
    );

    expect(find.text('Aug 16, 2026'), findsOneWidget);
    expect(find.textContaining('12:00 AM'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category trend communicates its period and axis labels', (
    tester,
  ) async {
    final category = ExpensesMockData.categorySummaries(
      ExpensePeriod.week,
    ).first;
    await pumpScreen(
      tester,
      ExpenseCategoryDetailsScreen(
        category: category,
        period: ExpensePeriod.week,
      ),
    );

    expect(find.text('1W category trend'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Sat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
