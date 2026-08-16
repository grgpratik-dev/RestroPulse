import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_categories_screen.dart';

void main() {
  testWidgets('adds and deletes a custom expense category', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ExpenseCategoriesScreen()),
    );

    expect(find.text('11 categories'), findsOneWidget);
    expect(find.text('2 fixed · 9 variable'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('expense-category-add-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('expense-category-name-field')),
      'Insurance',
    );
    await tester.tap(
      find.byKey(const ValueKey('expense-category-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('12 categories'), findsOneWidget);
    expect(find.text('Insurance'), findsOneWidget);

    final actions = find.byTooltip('Insurance category actions');
    await tester.scrollUntilVisible(
      actions,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(actions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Insurance?'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('confirm-delete-expense-category-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Insurance'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('11 categories'),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('11 categories'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
