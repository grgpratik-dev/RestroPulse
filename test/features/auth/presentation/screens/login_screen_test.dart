import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/auth/presentation/screens/login/login_screen.dart';

void main() {
  testWidgets('shows the login UI and toggles password visibility', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    final googleMark = tester.widget<Image>(
      find.byKey(const ValueKey('login-google-mark')),
    );
    expect(
      (googleMark.image as AssetImage).assetName,
      'assets/images/google_logo.png',
    );

    final submitButton = find.byKey(const ValueKey('login-submit-button'));
    expect(tester.getSize(submitButton).width, greaterThan(300));

    final passwordField = find.descendant(
      of: find.byKey(const ValueKey('login-password-field')),
      matching: find.byType(EditableText),
    );
    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    await tester.tap(find.byKey(const ValueKey('login-password-visibility')));
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
  });

  testWidgets('remains scrollable on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pump();

    expect(find.text('Create account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
