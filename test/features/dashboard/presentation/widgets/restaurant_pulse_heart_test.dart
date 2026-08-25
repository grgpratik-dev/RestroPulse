import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/dashboard/presentation/widgets/restaurant_pulse_card.dart';

void main() {
  testWidgets('shows the compact Restaurant Pulse health summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: RestaurantPulseCard(
            hasData: true,
            onAddOrder: () {},
            onAddExpense: () {},
          ),
        ),
      ),
    );

    expect(find.text('Restaurant Pulse'), findsOneWidget);
    expect(find.text('84 / 100'), findsOneWidget);
    expect(find.text('Excellent Health'), findsOneWidget);
    expect(find.text('↑ 4 points vs last week'), findsOneWidget);
    expect(find.text('Strong'), findsOneWidget);
    expect(find.text('Healthy'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
