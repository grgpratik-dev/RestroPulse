import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_entry_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_screen.dart';

void main() {
  Future<void> pumpAtMobileSize(WidgetTester tester, Widget child) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: child));
  }

  testWidgets('shows the order-derived sales overview with NPR formatting', (
    tester,
  ) async {
    await pumpAtMobileSize(tester, const SalesScreen());

    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Today · Aug 16'), findsOneWidget);
    expect(find.text('Rs 28,450'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Average Order'), findsOneWidget);
    expect(find.text('Rs 677'), findsOneWidget);
    expect(find.text('55%'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);
    expect(find.text('Rs 15,648'), findsOneWidget);
    expect(find.text('Rs 7,113'), findsOneWidget);
    expect(find.text('Rs 5,689'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Sales by Channel')).dy,
      lessThan(tester.getTopLeft(find.text('Recent Orders')).dy),
    );
    expect(find.text('View History →'), findsOneWidget);
    expect(find.text('Sales Trend'), findsNothing);
    expect(find.text('1W'), findsNothing);
    expect(find.text('1M'), findsNothing);
    expect(find.text('3M'), findsNothing);
    expect(find.text('6M'), findsNothing);
    expect(find.text('1Y'), findsNothing);
    expect(find.textContaining('₹'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not save an order without menu items', (tester) async {
    await pumpAtMobileSize(tester, const OrderEntryScreen());

    await tester.tap(find.byKey(const ValueKey('save-order-button')));
    await tester.pump();

    expect(find.text('Add at least one menu item.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('batch entry saves and prepares the next order', (tester) async {
    await pumpAtMobileSize(tester, const OrderEntryScreen(isBatchMode: true));

    await tester.tap(find.text('Chicken Momo').first);
    await tester.tap(find.byKey(const ValueKey('save-order-button')));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('1 orders entered'), findsOneWidget);
    expect(find.text('Order saved. Ready for the next bill.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
