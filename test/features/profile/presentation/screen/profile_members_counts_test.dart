import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/profile/presentation/cubits/members_access/members_access_cubit.dart';
import 'package:restropulse/src/features/profile/presentation/screen/profile_screen.dart';
import '../../../../support/fake_access_management_repository.dart';

void main() {
  late FakeAccessManagementRepository repository;
  setUp(() {
    repository = FakeAccessManagementRepository();
    sl.registerFactory<MembersAccessCubit>(
      () => MembersAccessCubit(repository),
    );
  });
  tearDown(() => sl.reset());

  testWidgets('refreshes member and pending counts after returning', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => ProfileScreen(onLogout: () {}),
        ),
        GoRoute(
          path: '/members',
          name: AppRoute.membersAccess.name,
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () async {
                await repository.approve('request');
                if (context.mounted) context.pop();
              },
              child: const Text('Approve and return'),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();
    final tile = find.text('Members & Access');
    await tester.ensureVisible(tile);
    expect(find.text('1 member · 1 pending request'), findsOneWidget);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Approve and return'));
    await tester.pumpAndSettle();
    expect(find.text('2 members · 0 pending requests'), findsOneWidget);
    expect(repository.loads, 2);
  });

  testWidgets('viewers see only the member count', (tester) async {
    repository.owner = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ProfileScreen(onLogout: () {}),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Members & Access'));
    expect(find.text('1 member'), findsOneWidget);
    expect(find.textContaining('pending request'), findsNothing);
  });
}
