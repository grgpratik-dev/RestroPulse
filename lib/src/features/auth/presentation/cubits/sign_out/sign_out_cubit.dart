import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_out_usecase.dart';

import 'sign_out_state.dart';

final class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._signOutUsecase) : super(const SignOutState());

  final SignOutUsecase _signOutUsecase;

  Future<void> signOut() async {
    if (state.status == SignOutStatus.loading) return;

    emit(const SignOutState(status: SignOutStatus.loading));

    final result = await _signOutUsecase(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        SignOutState(status: SignOutStatus.failure, message: failure.message),
      ),
      (_) => emit(const SignOutState(status: SignOutStatus.success)),
    );
  }
}
