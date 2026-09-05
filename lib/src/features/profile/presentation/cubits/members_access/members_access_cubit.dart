import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../restaurant_access/domain/entities/access_management.dart';
import '../../../../restaurant_access/domain/repositories/access_management_repository.dart';
part 'members_access_cubit.freezed.dart';

@freezed
abstract class MembersAccessState with _$MembersAccessState {
  const factory MembersAccessState({
    @Default(false) bool loading,
    @Default(false) bool saving,
    MembersAccess? data,
    String? message,
  }) = _MembersAccessState;
}

final class MembersAccessCubit extends Cubit<MembersAccessState> {
  MembersAccessCubit(this._repository) : super(const MembersAccessState());
  final AccessManagementRepository _repository;

  Future<void> load() async {
    if (state.loading || state.saving) return;
    emit(state.copyWith(loading: true, message: null));
    await _reload();
  }

  Future<void> _reload() async {
    final result = await _repository.getMembersAccess();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(loading: false, saving: false, message: failure.message),
      ),
      (data) => emit(MembersAccessState(data: data)),
    );
  }

  Future<void> generateCode() => _mutate(_repository.generateCode);
  Future<void> disableCode() => _mutate(_repository.disableCode);
  Future<void> approve(String id) => _mutate(() => _repository.approve(id));
  Future<void> decline(String id) => _mutate(() => _repository.decline(id));
  Future<void> removeViewer(String id) =>
      _mutate(() => _repository.removeViewer(id));

  Future<void> _mutate(Future<Either<Failure, Unit>> Function() action) async {
    if (state.loading || state.saving || state.data?.isOwner != true) return;
    emit(state.copyWith(saving: true, message: null));
    final result = await action();
    if (isClosed) return;
    await result.fold(
      (failure) async =>
          emit(state.copyWith(saving: false, message: failure.message)),
      (_) => _reload(),
    );
  }
}
