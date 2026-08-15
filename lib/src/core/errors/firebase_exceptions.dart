import '../enums/enums.dart';

/// An SDK-independent representation of an error reported by Firebase.
///
/// Firebase packages are intentionally not imported here. When Firebase is
/// added to an app, pass the SDK exception's code, message, and plugin to
/// [AppFirebaseException.fromCode].
class AppFirebaseException implements Exception {
  const AppFirebaseException({
    required this.type,
    required this.code,
    required this.message,
    this.plugin,
    this.originalMessage,
    this.originalError,
    this.stackTrace,
  });

  factory AppFirebaseException.fromCode({
    required String code,
    String? message,
    String? plugin,
    Object? originalError,
    StackTrace? stackTrace,
  }) {
    final normalizedCode = _normalizeCode(code);
    final type = _typeFromCode(normalizedCode);

    return AppFirebaseException(
      type: type,
      code: code,
      message: _messageFromType(type),
      plugin: plugin,
      originalMessage: message,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  final FirebaseErrorType type;

  /// The original Firebase code, kept for logging and feature-specific logic.
  final String code;

  /// A safe message that can be shown to the user.
  final String message;

  /// The Firebase service that failed, such as `firebase_auth`.
  final String? plugin;

  /// The original Firebase message, kept for diagnostics rather than UI text.
  final String? originalMessage;
  final Object? originalError;
  final StackTrace? stackTrace;
}

String _normalizeCode(String code) {
  return code.trim().toLowerCase().split('/').last;
}

FirebaseErrorType _typeFromCode(String code) {
  return switch (code) {
    'cancelled' || 'canceled' => FirebaseErrorType.cancelled,
    'network-request-failed' => FirebaseErrorType.network,
    'unauthenticated' => FirebaseErrorType.unauthenticated,
    'permission-denied' || 'unauthorized' => FirebaseErrorType.permissionDenied,
    'not-found' ||
    'object-not-found' ||
    'bucket-not-found' => FirebaseErrorType.notFound,
    'already-exists' => FirebaseErrorType.alreadyExists,
    'invalid-argument' => FirebaseErrorType.invalidArgument,
    'invalid-credential' ||
    'wrong-password' ||
    'invalid-verification-code' ||
    'invalid-verification-id' => FirebaseErrorType.invalidCredential,
    'user-disabled' => FirebaseErrorType.userDisabled,
    'user-not-found' => FirebaseErrorType.userNotFound,
    'email-already-in-use' || 'account-exists-with-different-credential' =>
      FirebaseErrorType.emailAlreadyInUse,
    'weak-password' => FirebaseErrorType.weakPassword,
    'too-many-requests' => FirebaseErrorType.tooManyRequests,
    'quota-exceeded' => FirebaseErrorType.quotaExceeded,
    'unavailable' || 'retry-limit-exceeded' => FirebaseErrorType.unavailable,
    'requires-recent-login' => FirebaseErrorType.requiresRecentLogin,
    'operation-not-allowed' => FirebaseErrorType.operationNotAllowed,
    _ => FirebaseErrorType.unknown,
  };
}

String _messageFromType(FirebaseErrorType type) {
  return switch (type) {
    FirebaseErrorType.cancelled => 'The operation was cancelled.',
    FirebaseErrorType.network =>
      'Unable to connect. Check your internet connection.',
    FirebaseErrorType.unauthenticated => 'Authentication is required.',
    FirebaseErrorType.permissionDenied =>
      'You do not have permission to do this.',
    FirebaseErrorType.notFound => 'The requested data was not found.',
    FirebaseErrorType.alreadyExists => 'This data already exists.',
    FirebaseErrorType.invalidArgument =>
      'Some of the provided information is invalid.',
    FirebaseErrorType.invalidCredential =>
      'The provided credentials are invalid.',
    FirebaseErrorType.userDisabled => 'This account has been disabled.',
    FirebaseErrorType.userNotFound => 'No account was found.',
    FirebaseErrorType.emailAlreadyInUse =>
      'An account already exists for this email.',
    FirebaseErrorType.weakPassword => 'The password is too weak.',
    FirebaseErrorType.tooManyRequests =>
      'Too many attempts. Please try again later.',
    FirebaseErrorType.quotaExceeded =>
      'The service limit has been reached. Please try again later.',
    FirebaseErrorType.unavailable =>
      'The service is temporarily unavailable. Please try again.',
    FirebaseErrorType.requiresRecentLogin =>
      'Please sign in again before continuing.',
    FirebaseErrorType.operationNotAllowed =>
      'This operation is not currently available.',
    FirebaseErrorType.unknown => 'An unexpected Firebase error occurred.',
  };
}
