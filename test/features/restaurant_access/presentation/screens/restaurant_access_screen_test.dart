import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/widgets/app_bottom_navigation_bar.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/restaurant_access_screen.dart';

void main() {
  testWidgets('offers owner and viewer paths without application navigation', (
    tester,
  ) async {
    var createSelected = false;
    var joinSelected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RestaurantAccessScreen(
          onCreateRestaurant: () => createSelected = true,
          onJoinRestaurant: () => joinSelected = true,
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppBottomNavigationBar), findsNothing);
    expect(find.text('Create your restaurant'), findsOneWidget);
    expect(find.text('Owner access'), findsOneWidget);
    expect(find.text('Join a restaurant'), findsOneWidget);
    expect(find.text('Viewer access'), findsOneWidget);
    expect(
      find.text('View only — you cannot add, edit, or delete data'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('create-restaurant-option')));
    final joinOption = find.byKey(const ValueKey('join-restaurant-option'));
    await tester.ensureVisible(joinOption);
    await tester.pump();
    await tester.tap(joinOption);

    expect(createSelected, isTrue);
    expect(joinSelected, isTrue);
    expect(tester.takeException(), isNull);
  });
}
