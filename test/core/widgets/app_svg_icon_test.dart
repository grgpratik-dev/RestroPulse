import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';
import 'package:restropulse/src/features/expenses/domain/models/expense.dart';
import 'package:restropulse/src/features/expenses/presentation/widgets/expense_category_icon.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/order_channel_icon.dart';

void main() {
  test('every default expense category has a specific SVG asset', () {
    final assets = ExpenseCategories.defaults
        .map(expenseCategoryIconAsset)
        .toList();

    expect(assets, hasLength(ExpenseCategories.defaults.length));
    expect(assets.toSet(), hasLength(ExpenseCategories.defaults.length));
    expect(assets.every((asset) => asset.startsWith('assets/svg/')), isTrue);
    expect(assets.every((asset) => asset.endsWith('.svg')), isTrue);
  });

  test('every order channel has a specific SVG asset', () {
    final assets = OrderChannel.values.map(orderChannelIconAsset).toList();

    expect(assets.toSet(), hasLength(OrderChannel.values.length));
    expect(assets.every((asset) => asset.startsWith('assets/svg/')), isTrue);
    expect(assets.every((asset) => asset.endsWith('.svg')), isTrue);
  });

  testWidgets(
    'category and order assets render through the shared SVG widget',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                ExpenseCategoryIcon(category: 'Ingredients'),
                OrderChannelIcon(channel: OrderChannel.delivery),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('keeps artwork compact inside a tightly constrained icon slot', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox.square(
          dimension: 48,
          child: AppIcon(AppIcons.email_outlined),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SvgPicture)), const Size.square(24));
  });
}
