part of 'app_bloc.dart';

/// The two session states that the whole application needs to understand.
enum SessionStatus { authenticated, unauthenticated }

final class AppState extends Equatable {
  const AppState({this.status});

  /// Null means the application is still restoring the stored session.
  final SessionStatus? status;

  bool get isAuthenticated => status == SessionStatus.authenticated;

  @override
  List<Object?> get props => [status];
}
