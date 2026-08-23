import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/auth/domain/entities/auth_credentials.dart';
import 'package:restropulse/src/features/auth/domain/entities/sign_up_result.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_in/sign_in_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('shows the login UI and toggles password visibility', (
    tester,
  ) async {
    await _pumpLoginScreen(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    final googleMark = tester.widget<Image>(
      find.byKey(const ValueKey('login-google-mark')),
    );
    expect(
      (googleMark.image as AssetImage).assetName,
      'assets/images/google_logo.png',
    );

    final submitButton = find.byKey(const ValueKey('login-submit-button'));
    expect(tester.getSize(submitButton).width, greaterThan(300));

    final passwordField = find.descendant(
      of: find.byKey(const ValueKey('login-password-field')),
      matching: find.byType(EditableText),
    );
    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    await tester.tap(find.byKey(const ValueKey('login-password-visibility')));
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
  });

  testWidgets('remains scrollable on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpLoginScreen(tester);

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pump();

    expect(find.text('Create account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submits through the Cubit provided to the login screen', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    final resultCompleter = Completer<Either<Failure, AuthResponse>>();
    repository.signInResult = resultCompleter.future;

    await _pumpLoginScreen(tester, repository: repository);

    await tester.enterText(
      find.byType(EditableText).at(0),
      'owner@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.tap(find.byKey(const ValueKey('login-submit-button')));
    await tester.pump();

    expect(repository.receivedCredentials?.email, 'owner@example.com');
    expect(repository.receivedCredentials?.password, 'password123');
    expect(find.text('Signing in...'), findsOneWidget);

    resultCompleter.complete(
      const Left(SupabaseFailure('The email or password is incorrect.')),
    );
    await tester.pumpAndSettle();

    expect(find.text('The email or password is incorrect.'), findsOneWidget);
  });
}

Future<void> _pumpLoginScreen(
  WidgetTester tester, {
  _FakeAuthRepository? repository,
}) {
  return tester.pumpWidget(
    BlocProvider(
      create: (_) =>
          SignInCubit(SignInUsecase(repository ?? _FakeAuthRepository())),
      child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    ),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  Future<Either<Failure, AuthResponse>> signInResult = Future.value(
    Right(AuthResponse()),
  );
  AuthCredentials? receivedCredentials;

  @override
  Future<Either<Failure, AuthResponse>> signInWithEmail(
    AuthCredentials credentials,
  ) async {
    receivedCredentials = credentials;
    return signInResult;
  }

  @override
  Future<Either<Failure, SignUpResult>> signUpWithEmail(
    AuthCredentials credentials,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    throw UnimplementedError();
  }
}
