import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/profile/presentation/screen/edit_restaurant/edit_restaurant_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/personal_informatin/personal_information_screen.dart';

void main() {
  testWidgets('edits restaurant-specific information', (tester) async {
    var saved = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: EditRestaurantScreen(onSaved: () => saved = true),
      ),
    );

    expect(find.text('Edit Restaurant'), findsOneWidget);
    expect(find.text('Restaurant details'), findsOneWidget);
    expect(find.text('Boys to Serve'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('save-restaurant-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('save-restaurant-button')));
    await tester.pump();

    expect(saved, isTrue);
    expect(find.text('Restaurant details updated.'), findsOneWidget);
  });

  testWidgets('keeps personal information separate from restaurant details', (
    tester,
  ) async {
    var saved = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: PersonalInformationScreen(onSaved: () => saved = true),
      ),
    );

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Account holder'), findsOneWidget);
    expect(find.text('Pratik Gurung'), findsOneWidget);
    expect(find.text('Owner · Boys to Serve'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('save-personal-information-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
      find.byKey(const ValueKey('save-personal-information-button')),
    );
    await tester.pump();

    expect(saved, isTrue);
    expect(find.text('Personal information updated.'), findsOneWidget);
  });
}
