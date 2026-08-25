import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/recent_orders_section.dart';

void main() {
  testWidgets('shows recent order details and opens an order', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SalesOrder? tappedOrder;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RecentOrdersSection(
              orders: SalesMockData.todayOrders,
              onOrderTap: (order) => tappedOrder = order,
              onViewHistory: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Recent Orders'), findsOneWidget);
    expect(find.text('View History →'), findsOneWidget);
    for (final order in SalesMockData.todayOrders) {
      expect(find.byKey(ValueKey('order-card-${order.id}')), findsOneWidget);
    }
    expect(find.text('Dine-in'), findsWidgets);
    expect(find.text('3 items'), findsWidgets);
    expect(find.byType(ChoiceChip), findsNothing);

    await tester.tap(
      find.byKey(ValueKey('order-card-${SalesMockData.todayOrders.first.id}')),
    );
    expect(tappedOrder, SalesMockData.todayOrders.first);
    expect(tester.takeException(), isNull);
  });
}
