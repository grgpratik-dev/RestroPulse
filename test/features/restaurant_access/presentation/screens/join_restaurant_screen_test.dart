import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/join_restaurant/join_restaurant_cubit.dart';
import '../../../../support/fake_access_management_repository.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/widgets/app_bottom_navigation_bar.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/join_restaurant_screen.dart';

void main() {
  setUp(
    () => sl.registerFactory<JoinRestaurantCubit>(
      () => JoinRestaurantCubit(FakeAccessManagementRepository()),
    ),
  );
  tearDown(() => sl.reset());
  testWidgets('verifies an invitation before joining as viewer', (
    tester,
  ) async {
    var joined = false;
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: JoinRestaurantScreen(onJoined: () => joined = true),
      ),
    );

    expect(find.byType(AppBottomNavigationBar), findsNothing);
    expect(find.text('Viewer access'), findsOneWidget);
    expect(find.byKey(const ValueKey('invitation-preview-card')), findsNothing);

    final findButton = find.byKey(const ValueKey('find-restaurant-button'));
    await tester.tap(findButton);
    await tester.pump();
    expect(find.text('Enter your invitation code'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('invitation-code-field')),
      'RP-7K9M2',
    );
    await tester.tap(findButton);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('invitation-preview-card')),
      findsOneWidget,
    );
    expect(find.text('Test Kitchen'), findsOneWidget);
    expect(find.text('Invited by owner'), findsOneWidget);

    final joinButton = find.byKey(const ValueKey('confirm-join-button'));
    await tester.ensureVisible(joinButton);
    await tester.pump();
    await tester.tap(joinButton);

    await tester.pumpAndSettle();

    expect(joined, isTrue);
    expect(find.text('Request sent'), findsOneWidget);
    expect(find.text('Waiting for owner approval'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
