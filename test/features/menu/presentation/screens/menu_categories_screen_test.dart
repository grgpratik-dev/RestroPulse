import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_categories_screen.dart';

void main() {
  testWidgets('adds and safely deletes an empty category', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const MenuCategoriesScreen()),
    );

    expect(find.text('5 categories'), findsOneWidget);
    expect(find.text('38 menu items organized'), findsOneWidget);
    expect(find.text('Momo'), findsOneWidget);
    expect(find.byIcon(Icons.ramen_dining_rounded), findsNothing);

    await tester.tap(find.byKey(const ValueKey('menu-category-add-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('menu-category-name-field')),
      'Desserts',
    );
    await tester.tap(find.byKey(const ValueKey('menu-category-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('6 categories'), findsOneWidget);
    expect(find.text('Desserts'), findsOneWidget);
    expect(find.text('0 menu items'), findsNothing);

    final actions = find.byTooltip('Desserts category actions');
    await tester.ensureVisible(actions);
    await tester.tap(actions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Desserts?'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('confirm-delete-category-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Desserts'), findsNothing);
    expect(find.text('5 categories'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
