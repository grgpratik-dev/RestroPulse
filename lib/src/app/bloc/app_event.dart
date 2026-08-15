part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

/// Checks whether an access token exists when the app starts.
final class AppStarted extends AppEvent {
  const AppStarted();
}

/// Internal event produced whenever SessionService changes globally.
final class AppSessionChanged extends AppEvent {
  const AppSessionChanged(this.status);

  final SessionStatus status;

  @override
  List<Object> get props => [status];
}
