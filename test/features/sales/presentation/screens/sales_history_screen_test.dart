import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_details_screen.dart';
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
    await tester.pumpAndSettle();
  }

  testWidgets('shows the lightweight period sales hierarchy', (tester) async {
    await pumpHistory(tester);

    expect(find.text('Sales History'), findsOneWidget);
    for (final period in ['1W', '1M', '3M', '6M', '1Y']) {
      expect(find.text(period), findsOneWidget);
    }
    expect(find.text('Aug 1 – Aug 16, 2026'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('Total Sales'), findsOneWidget);
    expect(find.textContaining('vs previous period'), findsOneWidget);
    expect(find.text('Orders'), findsWidgets);
    expect(find.text('Average Order'), findsOneWidget);
    expect(find.text('Sales Trend'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Sales by Channel'), findsOneWidget);

    expect(find.text('Profit'), findsNothing);
    expect(find.text('Restaurant Pulse'), findsNothing);
    expect(find.text('Recommendations'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changes range and chart grouping with the selected period', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.text('1W'));
    await tester.pumpAndSettle();

    expect(find.text('Aug 10 – Aug 16, 2026'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Weekly'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the custom date range picker', (tester) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(const ValueKey('sales-history-custom-range')));
    await tester.pumpAndSettle();

    expect(find.byType(DateRangePickerDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('groups orders by date and filters them by channel', (
    tester,
  ) async {
    await pumpHistory(tester);

    final pageScroll = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    await tester.scrollUntilVisible(
      find.text('Aug 15'),
      300,
      scrollable: pageScroll,
    );
    expect(find.text('Aug 15'), findsOneWidget);

    final deliveryFilter = find.widgetWithText(ChoiceChip, 'Delivery');
    await tester.scrollUntilVisible(
      deliveryFilter,
      -300,
      scrollable: pageScroll,
    );
    await tester.tap(deliveryFilter);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('order-card-order-39')),
      300,
      scrollable: pageScroll,
    );
    expect(find.byKey(const ValueKey('order-card-order-40')), findsOneWidget);
    expect(find.byKey(const ValueKey('order-card-order-39')), findsOneWidget);
    expect(find.byKey(const ValueKey('order-card-order-42')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the existing order details screen', (tester) async {
    await pumpHistory(tester);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('order-card-order-42')),
      300,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.tap(find.byKey(const ValueKey('order-card-order-42')));
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
