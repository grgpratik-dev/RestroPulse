import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';

void main() {
  testWidgets('builds horizontal and vertical material dividers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(child: AppDivider(height: 12, indent: 4)),
              AppDivider.vertical(width: 16, endIndent: 3),
            ],
          ),
        ),
      ),
    );

    final horizontal = tester.widget<Divider>(find.byType(Divider));
    final vertical = tester.widget<VerticalDivider>(
      find.byType(VerticalDivider),
    );

    expect(horizontal.height, 12);
    expect(horizontal.indent, 4);
    expect(vertical.width, 16);
    expect(vertical.endIndent, 3);
  });

  testWidgets('uses the common spacing and line thickness by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(child: AppDivider()),
              AppDivider.vertical(),
            ],
          ),
        ),
      ),
    );

    final horizontal = tester.widget<Divider>(find.byType(Divider));
    final vertical = tester.widget<VerticalDivider>(
      find.byType(VerticalDivider),
    );

    expect(horizontal.height, AppSpacing.spaceLg);
    expect(horizontal.thickness, 1);
    expect(vertical.width, AppSpacing.spaceLg);
    expect(vertical.thickness, 1);
  });
}
