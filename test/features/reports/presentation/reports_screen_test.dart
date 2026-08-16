import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/reports/presentation/screen/reports_screen.dart';

void main() {
  Future<void> pumpReports(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ReportsScreen()),
    );
  }

  testWidgets('complete report presents insights before detailed sections', (
    tester,
  ) async {
    await pumpReports(tester);

    expect(find.text('August 2026'), findsOneWidget);
    expect(find.text('Performance Overview'), findsOneWidget);
    expect(find.text('Revenue vs Expenses'), findsOneWidget);
    expect(find.text('What Changed?'), findsOneWidget);
    expect(find.text('Financial Breakdown'), findsOneWidget);
    expect(find.text('Drivers & Impact'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('What Changed?')).dy,
      lessThan(tester.getTopLeft(find.text('Financial Breakdown')).dy),
    );

    expect(find.text('= Gross profit'), findsOneWidget);
    expect(find.text('= Estimated net profit'), findsOneWidget);
    expect(find.text('− Estimated food cost'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Check Expenses'), findsOneWidget);
    expect(find.text('Where Money Went'), findsNothing);
    expect(find.text('Sales by Channel'), findsNothing);
    expect(find.text('Menu Performance'), findsNothing);
    expect(find.text('Order Behaviour'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('period selection updates operational report values', (
    tester,
  ) async {
    await pumpReports(tester);

    await tester.tap(find.text('1Y'));
    await tester.pumpAndSettle();

    expect(find.text('September 2025–August 2026'), findsOneWidget);
    expect(find.text('Rs 4,958,300'), findsWidgets);
    expect(find.text('Dine-in'), findsOneWidget);
    expect(find.text('Rs 968,400'), findsOneWidget);
    expect(find.text('Rs 128,400'), findsWidgets);
    expect(find.text('Rs 671'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
