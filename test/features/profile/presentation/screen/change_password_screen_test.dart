import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/profile/presentation/screen/change_password/change_password_screen.dart';

void main() {
  testWidgets('validates and submits a matching secure password', (
    tester,
  ) async {
    var changed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChangePasswordScreen(onPasswordChanged: () => changed = true),
      ),
    );

    expect(find.text('Secure your account'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('current-password-field')),
      'OldPassword1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('new-password-field')),
      'NewPassword2',
    );
    await tester.enterText(
      find.byKey(const ValueKey('confirm-new-password-field')),
      'NewPassword2',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('change-password-submit-button')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
      find.byKey(const ValueKey('change-password-submit-button')),
    );
    await tester.pump();

    expect(changed, isTrue);
    expect(find.text('Password updated.'), findsOneWidget);
  });

  testWidgets('rejects a confirmation that does not match', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ChangePasswordScreen()),
    );

    await tester.enterText(
      find.byKey(const ValueKey('current-password-field')),
      'OldPassword1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('new-password-field')),
      'NewPassword2',
    );
    await tester.enterText(
      find.byKey(const ValueKey('confirm-new-password-field')),
      'Different3',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('change-password-submit-button')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
      find.byKey(const ValueKey('change-password-submit-button')),
    );
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
