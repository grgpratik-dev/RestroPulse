import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_screen.dart';

void main() {
  testWidgets('menu supports category filtering and a confirmed delete flow', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const MenuScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chicken Burger'), findsOneWidget);
    final imageAssets = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => (image.image as AssetImage).assetName);
    expect(imageAssets, contains('assets/images/menu_chicken_momo.jpg'));
    expect(imageAssets, contains('assets/images/menu_chicken_burger.jpg'));
    expect(find.text('Active'), findsNothing);
    expect(find.text('Inactive'), findsNothing);
    expect(find.text('All Items'), findsNothing);
    expect(find.text('All Categories'), findsOneWidget);
    expect(find.text('By Profitability'), findsNothing);

    await tester.tap(find.text('3M'));
    await tester.pumpAndSettle();

    expect(find.text('June–August 2026'), findsOneWidget);
    expect(find.text('372'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('menu-category-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('menu-category-Burgers')));
    await tester.pumpAndSettle();

    expect(find.text('Chicken Burger'), findsOneWidget);
    expect(find.text('Chicken Momo'), findsNothing);

    await tester.tap(find.byTooltip('Item actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete item'));
    await tester.pumpAndSettle();

    expect(find.text('Delete this menu item?'), findsOneWidget);
    expect(
      find.text(
        'This removes the item from your current menu. Its historical sales will remain available in reports.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Delete Item'));
    await tester.pumpAndSettle();

    expect(find.text('Chicken Burger'), findsNothing);
    expect(find.text('Menu item deleted'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
