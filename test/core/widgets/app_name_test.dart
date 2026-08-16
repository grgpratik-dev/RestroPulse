import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';

void main() {
  testWidgets('uses readable brand colors on light backgrounds', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(builder: (context) => appName(context: context)),
      ),
    );

    final wordmark = tester.widget<Text>(find.byType(Text));
    final span = wordmark.textSpan! as TextSpan;

    expect(wordmark.style?.color, AppColors.ink);
    expect(span.children!.single.style?.color, AppColors.primary);
  });
}
