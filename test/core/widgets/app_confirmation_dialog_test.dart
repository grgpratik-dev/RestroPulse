import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';

void main() {
  testWidgets('returns the selected confirmation result', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showDialog<bool>(
                  context: context,
                  builder: (context) => const AppConfirmationDialog(
                    title: 'Delete item?',
                    message: 'This cannot be undone.',
                    confirmLabel: 'Delete',
                    isDestructive: true,
                  ),
                );
              },
              child: const Text('Open dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Delete item?'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text('Delete item?'), findsNothing);
  });

  testWidgets('supports an informational single-action dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppConfirmationDialog(
            title: 'About',
            message: 'Version 1.0.0',
            confirmLabel: 'Close',
            showCancelButton: false,
          ),
        ),
      ),
    );

    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);
  });
}
