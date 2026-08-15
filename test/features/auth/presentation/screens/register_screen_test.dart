import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/auth/presentation/screens/register/register_screen.dart';

void main() {
  testWidgets('shows the registration UI and password controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const RegisterScreen()),
    );

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.byKey(const ValueKey('register-login-button')), findsOneWidget);

    final submitButton = find.byKey(const ValueKey('register-submit-button'));
    expect(tester.getSize(submitButton).width, greaterThan(300));

    final passwordField = find.descendant(
      of: find.byKey(const ValueKey('register-password-field')),
      matching: find.byType(EditableText),
    );
    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    final visibilityButton = find.byKey(
      const ValueKey('register-password-visibility'),
    );
    await tester.ensureVisible(visibilityButton);
    await tester.tap(visibilityButton);
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
  });

  testWidgets('remains scrollable on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const RegisterScreen()),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('register-submit-button')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
