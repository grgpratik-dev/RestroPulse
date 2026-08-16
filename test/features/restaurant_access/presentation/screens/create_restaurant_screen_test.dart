import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/widgets/app_bottom_navigation_bar.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/create_restaurant_screen.dart';

void main() {
  testWidgets('validates the owner setup and creates a restaurant', (
    tester,
  ) async {
    var created = false;
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: CreateRestaurantScreen(onCreated: () => created = true),
      ),
    );

    expect(find.byType(AppBottomNavigationBar), findsNothing);
    expect(find.text('Owner setup'), findsOneWidget);
    expect(find.text('NPR (Rs)'), findsOneWidget);

    final createButton = find.byKey(const ValueKey('create-restaurant-button'));
    await tester.ensureVisible(createButton);
    await tester.tap(createButton);
    await tester.pump();
    expect(find.text('Enter your restaurant name'), findsOneWidget);
    expect(created, isFalse);

    await tester.enterText(
      find.byKey(const ValueKey('restaurant-name-field')),
      'Boys to Serve',
    );
    await tester.enterText(
      find.byKey(const ValueKey('restaurant-location-field')),
      'Pokhara, Nepal',
    );
    await tester.ensureVisible(createButton);
    await tester.tap(createButton);

    expect(created, isTrue);
    expect(tester.takeException(), isNull);
  });
}
