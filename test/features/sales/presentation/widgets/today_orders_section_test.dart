import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/today_orders_section.dart';

void main() {
  testWidgets('shows structured order cards and filters by channel', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    OrderChannel? selectedChannel;
    SalesOrder? tappedOrder;

    Future<void> pumpSection() {
      return tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: TodayOrdersSection(
                orders: SalesMockData.todayOrders,
                selectedChannel: selectedChannel,
                onChannelSelected: (channel) {
                  selectedChannel = channel;
                },
                onOrderTap: (order) => tappedOrder = order,
                onViewHistory: () {},
              ),
            ),
          ),
        ),
      );
    }

    await pumpSection();

    for (final order in SalesMockData.todayOrders) {
      expect(find.byKey(ValueKey('order-card-${order.id}')), findsOneWidget);
    }
    expect(find.text('Dine-in'), findsWidgets);
    expect(find.text('3 items'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(
      find.byKey(ValueKey('order-card-${SalesMockData.todayOrders.first.id}')),
    );
    expect(tappedOrder, SalesMockData.todayOrders.first);

    await tester.ensureVisible(find.byType(ChoiceChip).last);
    await tester.tap(find.byType(ChoiceChip).last);
    await pumpSection();

    expect(selectedChannel, OrderChannel.delivery);
    expect(find.byKey(const ValueKey('order-card-order-40')), findsOneWidget);
    expect(find.byKey(const ValueKey('order-card-order-42')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
