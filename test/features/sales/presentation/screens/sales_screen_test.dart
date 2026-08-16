import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_entry_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_screen.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_card.dart';

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
    expect(
      tester.getTopLeft(find.text('Sales by Channel')).dy,
      lessThan(tester.getTopLeft(find.text('Sales Trend')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Sales Trend')).dy,
      lessThan(tester.getTopLeft(find.text("Today's Orders")).dy),
    );
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

  testWidgets(
    'sales trend stays focused on the recent Sunday to Saturday week',
    (tester) async {
      await pumpAtMobileSize(
        tester,
        const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: SalesTrendCard(),
          ),
        ),
      );

      expect(find.text('Best day'), findsOneWidget);
      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Rs 31,200'), findsOneWidget);
      expect(find.text('Last 7 days'), findsOneWidget);
      expect(find.text('Sun–Sat'), findsOneWidget);
      expect(find.text('1M'), findsNothing);
      expect(find.text('3M'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
