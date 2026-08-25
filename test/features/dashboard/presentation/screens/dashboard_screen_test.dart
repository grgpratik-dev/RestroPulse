import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  Future<void> pumpDashboard(
    WidgetTester tester, {
    DashboardViewState viewState = DashboardViewState.loaded,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: DashboardScreen(viewState: viewState),
      ),
    );
  }

  testWidgets('shows the focused restaurant overview', (tester) async {
    await pumpDashboard(tester);

    expect(find.text('Restaurant Pulse'), findsOneWidget);
    expect(find.text('84 / 100'), findsOneWidget);
    expect(find.text('Rs 28,450'), findsOneWidget);
    expect(find.text('142'), findsOneWidget);
    expect(find.text('Rs 201'), findsOneWidget);
    expect(find.text('Rs 7,650'), findsOneWidget);
    expect(find.text('28.4%'), findsOneWidget);
    expect(find.textContaining('₹'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows guidance instead of fake values when data is empty', (
    tester,
  ) async {
    await pumpDashboard(tester, viewState: DashboardViewState.empty);

    expect(find.text('Your Restaurant Pulse is waiting'), findsOneWidget);
    expect(find.text('Add First Order'), findsOneWidget);
    expect(find.text('Rs 28,450'), findsNothing);
    expect(find.text('84'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
