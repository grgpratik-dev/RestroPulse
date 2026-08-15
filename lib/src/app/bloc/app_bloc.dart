import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/session/session_service.dart';

part 'app_event.dart';
part 'app_state.dart';


/// Holds authentication state that affects the entire application.
final class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._sessionService) : super(const AppState()) {
    on<AppStarted>(_onStarted);
    on<AppSessionChanged>(_onSessionChanged);

    // Feature BLoCs do not need to communicate with AppBloc. A Dio 401 expires
    // SessionService, and this single subscription updates the whole app.
    _sessionSubscription = _sessionService.statusChanges.listen((status) {
      add(AppSessionChanged(status));
    });
  }

  final SessionService _sessionService;
  late final StreamSubscription<SessionStatus> _sessionSubscription;

  Future<void> _onStarted(AppStarted event, Emitter<AppState> emit) async {
    final status = await _sessionService.restoreSession();
    emit(AppState(status: status));
  }

  void _onSessionChanged(AppSessionChanged event, Emitter<AppState> emit) {
    emit(AppState(status: event.status));
  }

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    return super.close();
  }
}
