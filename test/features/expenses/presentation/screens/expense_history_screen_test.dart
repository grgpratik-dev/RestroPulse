import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_history_screen.dart';

void main() {
  Future<void> pumpHistory(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ExpenseHistoryScreen()),
    );
  }

  testWidgets('shows the current-month expense ledger grouped by date', (
    tester,
  ) async {
    await pumpHistory(tester);

    expect(find.text('Expense History'), findsOneWidget);
    expect(find.text('Aug 1 – Aug 16, 2026'), findsNWidgets(2));
    expect(find.text('Rs 73,100'), findsOneWidget);
    expect(find.text('5 transactions'), findsOneWidget);
    expect(find.text('Today · Aug 16'), findsOneWidget);
    expect(find.text('Chicken supplier'), findsOneWidget);
    expect(find.text('Monthly restaurant rent'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filters the ledger without adding analytics duplication', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(const ValueKey('expense-history-filter')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Fixed'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    expect(find.text('Rs 55,000'), findsWidgets);
    expect(find.text('1 transaction'), findsOneWidget);
    expect(find.text('Monthly restaurant rent'), findsOneWidget);
    expect(find.text('Chicken supplier'), findsNothing);
    expect(find.text('Expense Trend'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
