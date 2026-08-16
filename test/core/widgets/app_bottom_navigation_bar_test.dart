import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/widgets/app_bottom_navigation_bar.dart';

void main() {
  test('every destination has a distinct outlined and filled SVG', () {
    expect(items, hasLength(5));
    expect(items.map((item) => item.iconAsset).toSet(), hasLength(5));
    expect(items.map((item) => item.selectedIconAsset).toSet(), hasLength(5));

    for (final item in items) {
      expect(item.iconAsset, endsWith('_outlined.svg'));
      expect(item.selectedIconAsset, endsWith('_filled.svg'));
      expect(item.iconAsset, isNot(item.selectedIconAsset));
    }
  });

  testWidgets('renders SVG destinations and reports taps', (tester) async {
    var tappedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: AppBottomNavigationBar(
            selectedIndex: 0,
            onDestinationSelected: (index) => tappedIndex = index,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsWidgets);
    for (final item in items) {
      expect(find.text(item.label), findsOneWidget);
    }

    await tester.tap(find.text('Sales'));
    expect(tappedIndex, 1);
    expect(tester.takeException(), isNull);
  });
}
