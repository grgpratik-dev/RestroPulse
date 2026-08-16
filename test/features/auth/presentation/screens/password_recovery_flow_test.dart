import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:restropulse/src/features/auth/presentation/screens/reset_password_screen.dart';

void main() {
  testWidgets('requests a reset link without exposing account existence', (
    tester,
  ) async {
    String? requestedEmail;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ForgotPasswordScreen(
          initialEmail: 'owner@example.com',
          onSendResetLink: (email) async => requestedEmail = email,
        ),
      ),
    );

    expect(find.text('Forgot your password?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('send-reset-link-button')));
    await tester.pumpAndSettle();

    expect(requestedEmail, 'owner@example.com');
    expect(find.text('Check your email'), findsOneWidget);
    expect(
      find.textContaining('If an account exists for owner@example.com'),
      findsOneWidget,
    );
    expect(find.text('Resend reset link'), findsOneWidget);
  });

  testWidgets('sets a matching password from a recovery session', (
    tester,
  ) async {
    String? updatedPassword;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ResetPasswordScreen(
          onResetPassword: (password) async => updatedPassword = password,
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('reset-password-field')),
      'SecurePass2',
    );
    await tester.enterText(
      find.byKey(const ValueKey('reset-password-confirmation-field')),
      'SecurePass2',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('reset-password-submit-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('reset-password-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(updatedPassword, 'SecurePass2');
    expect(find.text('Password updated'), findsOneWidget);
    expect(find.text('Continue to sign in'), findsOneWidget);
  });

  testWidgets('rejects mismatched reset passwords', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ResetPasswordScreen()),
    );

    await tester.enterText(
      find.byKey(const ValueKey('reset-password-field')),
      'SecurePass2',
    );
    await tester.enterText(
      find.byKey(const ValueKey('reset-password-confirmation-field')),
      'Different3',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('reset-password-submit-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('reset-password-submit-button')),
    );
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
