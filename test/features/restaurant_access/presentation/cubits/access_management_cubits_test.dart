import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/access_management.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/join_restaurant/join_restaurant_cubit.dart';
import 'package:restropulse/src/features/profile/presentation/cubits/members_access/members_access_cubit.dart';
import '../../../../support/fake_access_management_repository.dart';

void main() {
  test('ignores a lookup result after the code changes', () async {
    final repository = FakeAccessManagementRepository()
      ..lookup = Completer<Either<Failure, JoinInvitation>>();
    final cubit = JoinRestaurantCubit(repository);
    addTearDown(cubit.close);
    cubit.codeChanged('RP-OLD123');
    final pending = cubit.lookup();
    cubit.codeChanged('RP-NEW123');
    repository.lookup!.complete(
      const Right(FakeAccessManagementRepository.invitation),
    );
    await pending;
    expect(cubit.state.invitation, isNull);
    expect(cubit.state.code, 'RP-NEW123');
  });

  test(
    'requires preview and submits only once using the confirmed code',
    () async {
      final repository = FakeAccessManagementRepository()
        ..submission = Completer<Either<Failure, Unit>>();
      final cubit = JoinRestaurantCubit(repository);
      addTearDown(cubit.close);
      await cubit.request();
      expect(repository.submissions, 0);
      cubit.codeChanged(' rp-abc123 ');
      await cubit.lookup();
      final pending = cubit.request();
      await cubit.request();
      cubit.codeChanged('RP-OTHER');
      repository.submission!.complete(const Right(unit));
      await pending;
      expect(repository.submissions, 1);
      expect(repository.submittedCode, 'RP-ABC123');
      expect(cubit.state.requestSent, isTrue);
    },
  );

  test('failed join leaves preview available for retry', () async {
    final repository = FakeAccessManagementRepository()
      ..submission = Completer<Either<Failure, Unit>>();
    final cubit = JoinRestaurantCubit(repository);
    addTearDown(cubit.close);
    cubit.codeChanged('RP-ABC123');
    await cubit.lookup();
    final pending = cubit.request();
    repository.submission!.complete(
      const Left(UnknownFailure('Code disabled')),
    );
    await pending;
    expect(cubit.state.requestSent, isFalse);
    expect(cubit.state.loading, isFalse);
    expect(cubit.state.message, 'Code disabled');
  });

  test('owner approval reloads requests and members from server', () async {
    final repository = FakeAccessManagementRepository();
    final cubit = MembersAccessCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    await cubit.approve('request');
    expect(repository.loads, 2);
    expect(cubit.state.data!.requests, isEmpty);
    expect(cubit.state.data!.members.length, 2);
    await cubit.removeViewer('viewer');
    expect(cubit.state.data!.members.length, 1);
  });

  test('viewer cannot call owner mutations', () async {
    final repository = FakeAccessManagementRepository()..owner = false;
    final cubit = MembersAccessCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    await cubit.generateCode();
    await cubit.disableCode();
    await cubit.approve('request');
    await cubit.decline('request');
    await cubit.removeViewer('viewer');
    expect(repository.mutations, 0);
  });

  test('mutation failure preserves the last server snapshot', () async {
    final repository = FakeAccessManagementRepository()
      ..failure = const UnknownFailure('Try again');
    final cubit = MembersAccessCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    await cubit.approve('request');
    expect(cubit.state.data!.requests.length, 1);
    expect(cubit.state.message, 'Try again');
    expect(cubit.state.saving, isFalse);
  });
}
