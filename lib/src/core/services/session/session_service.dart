import 'dart:async';

import '../../../app/bloc/app_bloc.dart';
import '../../logging/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Stores the login session and announces whenever that session changes.
///
/// The network layer can expire a session without knowing anything about
/// Flutter widgets, navigation, or BLoCs. The app-level BLoC listens to
/// [statusChanges] and updates the UI when a session expires.
final class SessionService {
  SessionService(this._secureStorage);

  final SecureStorageService _secureStorage;
  final _statusController = StreamController<SessionStatus>.broadcast();

  SessionStatus? _currentStatus;
  bool _isExpiring = false;

  Stream<SessionStatus> get statusChanges => _statusController.stream;

  /// Restores the session when the application starts.
  ///
  /// A stored token means the user was previously authenticated. The backend
  /// can still reject an expired token later, which will call [expireSession].
  Future<SessionStatus> restoreSession() async {
    final token = await _secureStorage.readAccessToken();
    final status = token != null && token.isNotEmpty
        ? SessionStatus.authenticated
        : SessionStatus.unauthenticated;

    _currentStatus = status;
    return status;
  }

  /// Saves a new access token after a successful login.
  Future<void> startSession(String accessToken) async {
    await _secureStorage.writeAccessToken(accessToken);
    _publish(SessionStatus.authenticated);
  }

  /// Clears the expired token and informs the app that login is required.
  Future<void> expireSession() async {
    // Several requests can return 401 at the same time. Notify the app once.
    if (_currentStatus == SessionStatus.unauthenticated || _isExpiring) return;

    _isExpiring = true;

    try {
      await _secureStorage.deleteAccessToken();
    } on Exception catch (error, stackTrace) {
      // The app must still log out even if clearing local storage fails.
      appLogger.log(
        message: 'Could not remove the expired access token.',
        loggerLevel: LoggerLevel.warning,
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isExpiring = false;
    }

    _publish(SessionStatus.unauthenticated);
  }

  void _publish(SessionStatus status) {
    if (_currentStatus == status) return;

    _currentStatus = status;
    _statusController.add(status);
  }

  Future<void> dispose() {
    return _statusController.close();
  }
}
