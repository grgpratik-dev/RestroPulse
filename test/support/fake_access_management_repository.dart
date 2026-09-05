import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/access_management.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/access_management_repository.dart';

class FakeAccessManagementRepository implements AccessManagementRepository {
  static const invitation = JoinInvitation(
    restaurantId: 'restaurant',
    name: 'Test Kitchen',
    address: 'Kathmandu',
  );
  bool owner = true;
  String? code = 'RP-ABC123';
  int loads = 0;
  int mutations = 0;
  int submissions = 0;
  String? submittedCode;
  Completer<Either<Failure, JoinInvitation>>? lookup;
  Completer<Either<Failure, Unit>>? submission;
  Failure? failure;
  final requests = <AccessPerson>[
    const AccessPerson(id: 'request', name: 'Applicant', role: 'viewer'),
  ];
  final members = <AccessPerson>[
    const AccessPerson(id: 'owner', name: 'Owner', role: 'owner'),
  ];

  @override
  Future<Either<Failure, JoinInvitation>> resolveCode(String code) async =>
      lookup == null ? const Right(invitation) : lookup!.future;
  @override
  Future<Either<Failure, Unit>> requestJoin(String code) async {
    submissions++;
    submittedCode = code;
    return submission == null ? const Right(unit) : submission!.future;
  }

  @override
  Future<Either<Failure, MembersAccess>> getMembersAccess() async {
    loads++;
    return Right(
      MembersAccess(
        restaurantName: 'Test Kitchen',
        isOwner: owner,
        joinCode: owner ? code : null,
        members: List.of(members),
        requests: owner ? List.of(requests) : [],
      ),
    );
  }

  Future<Either<Failure, Unit>> _change(void Function() change) async {
    mutations++;
    if (failure != null) return Left(failure!);
    change();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> generateCode() =>
      _change(() => code = 'RP-NEW123');
  @override
  Future<Either<Failure, Unit>> disableCode() => _change(() => code = null);
  @override
  Future<Either<Failure, Unit>> approve(String id) => _change(() {
    requests.removeWhere((r) => r.id == id);
    members.add(
      const AccessPerson(id: 'viewer', name: 'Applicant', role: 'viewer'),
    );
  });
  @override
  Future<Either<Failure, Unit>> decline(String id) =>
      _change(() => requests.removeWhere((r) => r.id == id));
  @override
  Future<Either<Failure, Unit>> removeViewer(String id) =>
      _change(() => members.removeWhere((m) => m.id == id));
}
