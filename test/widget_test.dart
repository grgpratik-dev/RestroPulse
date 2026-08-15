import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('splash glows outward from the logo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final logo = tester.widget<Image>(
      find.byKey(const ValueKey('splash-logo')),
    );
    final logoImage = logo.image as AssetImage;
    final logoScale = tester.widget<ScaleTransition>(
      find.byKey(const ValueKey('splash-logo-scale')),
    );
    final initialScale = logoScale.scale.value;

    expect(scaffold.backgroundColor, AppColors.splash);
    expect(logoImage.assetName, Assets.logo.applogo.path);
    expect(logo.width, 184);
    expect(find.byKey(const ValueKey('splash-pulse-glow')), findsOneWidget);
    expect(find.text('RestroPulse'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pump(const Duration(milliseconds: 120));

    expect(logoScale.scale.value, greaterThan(initialScale));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('splash stays still when animations are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: SplashScreen(),
        ),
      ),
    );

    final logoScale = tester.widget<ScaleTransition>(
      find.byKey(const ValueKey('splash-logo-scale')),
    );

    expect(logoScale.scale.value, 1);
    await tester.pump(const Duration(milliseconds: 500));
    expect(logoScale.scale.value, 1);
  });
}
