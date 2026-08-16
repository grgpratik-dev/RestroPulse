import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/restaurant_pulse_heart.dart';

void main() {
  const transformKey = ValueKey('restaurant-pulse-heart-transform');

  test('uses a healthy BPM and slows as the score declines', () {
    final healthyBpm = restaurantPulseBpmForScore(84);
    final moderateBpm = restaurantPulseBpmForScore(60);
    final lowBpm = restaurantPulseBpmForScore(25);

    expect(healthyBpm, inInclusiveRange(72, 82));
    expect(moderateBpm, lessThan(healthyBpm));
    expect(lowBpm, lessThan(moderateBpm));
    expect(restaurantPulseBpmForScore(-10), 36);
    expect(restaurantPulseBpmForScore(120), 82);
  });

  Future<void> pumpHeart(
    WidgetTester tester, {
    double score = 84,
    bool disableAnimations = false,
  }) async {
    tester.view
      ..physicalSize = const Size(300, 300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            body: Center(child: RestaurantPulseHeart(score: score)),
          ),
        ),
      ),
    );
  }

  double currentScale(WidgetTester tester) {
    return tester
        .widget<Transform>(find.byKey(transformKey))
        .transform
        .getMaxScaleOnAxis();
  }

  testWidgets('shows the score in a filled heart and visibly beats', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpHeart(tester);

    expect(find.text('84/100'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('restaurant-pulse-heart-fill')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        'Restaurant Pulse score: 84 out of 100, healthy steady heartbeat',
      ),
      findsOneWidget,
    );

    final restingScale = currentScale(tester);
    await tester.pump(const Duration(milliseconds: 70));
    expect(currentScale(tester), greaterThan(restingScale));

    await tester.pumpWidget(const SizedBox());
    semantics.dispose();
  });

  testWidgets('stays still when reduced motion is enabled', (tester) async {
    await pumpHeart(tester, disableAnimations: true);

    final restingScale = currentScale(tester);
    await tester.pump(const Duration(milliseconds: 500));

    expect(restingScale, 1);
    expect(currentScale(tester), restingScale);
    await tester.pumpWidget(const SizedBox());
  });
}
