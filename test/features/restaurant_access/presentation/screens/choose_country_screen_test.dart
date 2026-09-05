import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/country_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/choose_country/choose_country_cubit.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/choose_country_screen.dart';

void main() {
  setUp(() {
    final repository = CountryRepositoryImpl(rootBundle);
    sl.registerFactory<ChooseCountryCubit>(
      () => ChooseCountryCubit(repository),
    );
  });
  tearDown(() => sl.reset());

  testWidgets(
    'searches with keyboard, selects, clears search, and preserves selection on dismissal',
    (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ChooseCountryScreen(
            onContinue: (country) => selected = country,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final continueButton = find.byKey(
        const ValueKey('continue-country-button'),
      );
      expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('country-selector')));
      await tester.pumpAndSettle();
      final titlePosition = tester.getTopLeft(find.text('Select country'));
      final searchPosition = tester.getTopLeft(
        find.byKey(const ValueKey('country-search-field')),
      );
      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      scrollView.controller!.jumpTo(600);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Select country')), titlePosition);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('country-search-field'))),
        searchPosition,
      );
      scrollView.controller!.jumpTo(0);
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      final search = find.byKey(const ValueKey('country-search-field'));
      await tester.enterText(search, 'nPr');
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('country-NP')), findsOneWidget);
      expect(find.byKey(const ValueKey('country-US')), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byKey(const ValueKey('country-NP')));
      await tester.tap(find.byKey(const ValueKey('country-NP')));
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      expect(find.text('Nepal'), findsOneWidget);
      await tester.tap(continueButton);
      expect(selected, 'Nepal');

      await tester.tap(find.byKey(const ValueKey('country-selector')));
      await tester.pumpAndSettle();
      await tester.enterText(search, 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text('No countries found'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('country-AF')), findsOneWidget);
      await tester.enterText(search, 'Nepal');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<ListTile>(find.byKey(const ValueKey('country-NP')))
            .selected,
        isTrue,
      );
      Navigator.of(tester.element(search)).pop();
      await tester.pumpAndSettle();
      expect(find.text('Nepal'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
