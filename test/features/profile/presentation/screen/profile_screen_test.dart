import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_svg_icon.dart';
import 'package:restropulse/src/features/profile/presentation/screen/profile_screen.dart';

void main() {
  testWidgets('shows restaurant identity and opens the currency sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ProfileScreen()),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Boys to Serve'), findsOneWidget);
    expect(find.text('Pratik Gurung'), findsOneWidget);
    expect(find.text('Pokhara, Nepal'), findsOneWidget);
    expect(find.text('Edit Restaurant'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
    expect(find.text('Members & Access'), findsOneWidget);

    final currencyTile = find.text('Currency');
    await tester.ensureVisible(currencyTile);
    await tester.tap(currencyTile);
    await tester.pumpAndSettle();

    expect(find.text('Select currency'), findsOneWidget);
    expect(find.text('Nepalese Rupee'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppSvgIcon &&
            widget.asset == AppIcons.check_circle_rounded,
      ),
      findsOneWidget,
    );
  });

  testWidgets('confirms logout before invoking the callback', (tester) async {
    var didLogOut = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ProfileScreen(onLogout: () => didLogOut = true),
      ),
    );

    final logoutButton = find.byKey(const ValueKey('profile-logout-button'));
    await tester.scrollUntilVisible(
      logoutButton,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('logout-confirmation-dialog')),
      findsOneWidget,
    );
    expect(find.text('Log out of RestroPulse?'), findsOneWidget);
    expect(
      find.text(
        'You’ll need to sign in again to access your restaurant dashboard and reports.',
      ),
      findsOneWidget,
    );
    expect(didLogOut, isFalse);

    await tester.tap(find.widgetWithText(FilledButton, 'Log Out'));
    await tester.pumpAndSettle();

    expect(didLogOut, isTrue);
  });
}
