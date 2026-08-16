import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_screen.dart';

void main() {
  testWidgets('menu uses a confirmed delete flow without activation controls', (
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

    expect(find.text('Chicken Burger'), findsOneWidget);
    expect(find.text('Active'), findsNothing);
    expect(find.text('Inactive'), findsNothing);

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
