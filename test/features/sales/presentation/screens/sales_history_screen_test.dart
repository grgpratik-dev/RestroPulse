import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_history_screen.dart';

void main() {
  Future<void> pumpHistory(WidgetTester tester, {DateTime? initialDate}) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SalesHistoryScreen(initialDate: initialDate),
      ),
    );
  }

  testWidgets('shows the selected day directly without a history overview', (
    tester,
  ) async {
    await pumpHistory(tester);

    expect(find.text('Sales History'), findsOneWidget);
    expect(find.text('Sunday, Aug 16'), findsOneWidget);
    expect(find.text('Rs 28,450'), findsOneWidget);
    expect(find.text('Sales by Channel'), findsOneWidget);
    expect(find.byKey(const ValueKey('order-card-order-42')), findsOneWidget);
    expect(find.text('Daily Breakdown'), findsNothing);
    expect(find.text('Rs 85,250'), findsNothing);
    expect(find.text('Daily Sales'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar changes the date on the same screen', (tester) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(const ValueKey('sales-history-calendar')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Sales History'), findsOneWidget);
    expect(find.text('Saturday, Aug 15'), findsOneWidget);
    expect(find.text('Rs 25,600'), findsOneWidget);
    expect(find.text('38'), findsOneWidget);
    expect(find.byType(SalesHistoryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a useful empty state for a date without sales', (
    tester,
  ) async {
    await pumpHistory(tester, initialDate: DateTime(2026, 8, 13));

    expect(find.text('Thursday, Aug 13'), findsOneWidget);
    expect(find.text('No sales were recorded on this date.'), findsOneWidget);
    expect(find.text('Choose another date'), findsOneWidget);
    expect(find.text('Sales by Channel'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
