import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/profile/presentation/screen/members_access_screen.dart';

void main() {
  testWidgets('manages one join code and pending viewer requests', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const MembersAccessScreen()),
    );

    expect(find.text('2 members'), findsOneWidget);
    expect(find.text('RP-7K9M2'), findsOneWidget);
    expect(find.text('Nisha Thapa'), findsOneWidget);

    final regenerate = find.byKey(
      const ValueKey('regenerate-join-code-button'),
    );
    await tester.ensureVisible(regenerate);
    await tester.tap(regenerate);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('confirm-regenerate-code-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('RP-4N8Q6'), findsOneWidget);

    final approve = find.byKey(const ValueKey('approve-access-request-button'));
    await tester.ensureVisible(approve);
    await tester.pump();
    await tester.tap(approve);
    await tester.pump();

    expect(find.text('No pending access requests'), findsOneWidget);
    await tester.fling(find.byType(ListView), const Offset(0, 1200), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 members'), findsOneWidget);

    await tester.fling(find.byType(ListView), const Offset(0, -1600), 2000);
    await tester.pumpAndSettle();
    expect(find.text('Nisha Thapa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
