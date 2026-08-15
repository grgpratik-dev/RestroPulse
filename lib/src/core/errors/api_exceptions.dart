import 'package:dio/dio.dart';

import '../enums/enums.dart';

class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.customCode,
    this.originalError,
    this.stackTrace,
  });

  factory ApiException.from(Object error, {StackTrace? stackTrace}) {
    if (error is ApiException) return error;

    if (error is DioException) {
      return _fromDio(error, stackTrace);
    }

    if (error is FormatException) {
      return ApiException(
        type: ApiErrorType.parsing,
        message: 'The received data could not be processed.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return ApiException(
      type: ApiErrorType.unknown,
      message: 'An unexpected error occurred.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final int? customCode;
  final Object? originalError;
  final StackTrace? stackTrace;
}

ApiException _fromDio(DioException error, StackTrace? stackTrace) {
  final statusCode = error.response?.statusCode;
  final responseData = error.response?.data;

  late ApiErrorType type;
  late String defaultMessage;

  switch (error.type) {
    case DioExceptionType.cancel:
      type = ApiErrorType.cancelled;
      defaultMessage = 'The request was cancelled.';

    case DioExceptionType.connectionError:
      type = ApiErrorType.connection;
      defaultMessage = 'Unable to connect. Check your internet connection.';

    case DioExceptionType.connectionTimeout:
      type = ApiErrorType.timeout;
      defaultMessage = 'The connection timed out.';

    case DioExceptionType.sendTimeout:
      type = ApiErrorType.timeout;
      defaultMessage = 'The request timed out while sending data.';

    case DioExceptionType.receiveTimeout:
      type = ApiErrorType.timeout;
      defaultMessage = 'The server took too long to respond.';

    case DioExceptionType.transformTimeout:
      type = ApiErrorType.timeout;
      defaultMessage = 'The response took too long to process.';

    case DioExceptionType.badCertificate:
      type = ApiErrorType.badCertificate;
      defaultMessage = 'A secure connection could not be established.';

    case DioExceptionType.badResponse:
      type = _typeFromStatusCode(statusCode);
      defaultMessage = _messageFromStatusCode(statusCode);

    case DioExceptionType.unknown:
      type = ApiErrorType.unknown;
      defaultMessage = 'An unexpected network error occurred.';
  }

  return ApiException(
    type: type,
    message: _readServerMessage(responseData) ?? defaultMessage,
    statusCode: statusCode,
    customCode: _readCustomCode(responseData),
    originalError: error,
    stackTrace: stackTrace,
  );
}

ApiErrorType _typeFromStatusCode(int? statusCode) {
  if (statusCode == null) return ApiErrorType.unknown;

  if (statusCode >= 500 && statusCode <= 599) return ApiErrorType.server;

  return switch (statusCode) {
    400 => ApiErrorType.badRequest,
    401 => ApiErrorType.unauthorized,
    403 => ApiErrorType.forbidden,
    404 => ApiErrorType.notFound,
    405 => ApiErrorType.methodNotAllowed,
    408 => ApiErrorType.timeout,
    409 => ApiErrorType.conflict,
    415 => ApiErrorType.unsupportedMediaType,
    422 => ApiErrorType.validation,
    429 => ApiErrorType.tooManyRequests,
    >= 400 && <= 499 => ApiErrorType.client,
    _ => ApiErrorType.unknown,
  };
}

String _messageFromStatusCode(int? statusCode) {
  if (statusCode == null) return 'An unexpected network error occurred.';

  return switch (statusCode) {
    400 => 'The request was invalid.',
    401 => 'Authentication is required.',
    403 => 'You do not have permission to do this.',
    404 => 'The requested resource was not found.',
    405 => 'This operation is not allowed.',
    408 => 'The request timed out.',
    409 => 'The request conflicts with existing data.',
    415 => 'The submitted content type is not supported.',
    422 => 'Some submitted information is invalid.',
    429 => 'Too many requests. Please try again later.',
    >= 500 && <= 599 => 'The server could not complete the request.',
    >= 400 && <= 499 => 'The request could not be completed.',
    _ => 'An unexpected network error occurred.',
  };
}

String? _readServerMessage(Object? data) {
  if (data is String) return _safeMessage(data);
  if (data is! Map) return null;

  final message =
      data['message'] ??
      data['detail'] ??
      data['error_description'] ??
      data['title'];

  if (message is String) return _safeMessage(message);

  final error = data['error'];
  if (error is String) return _safeMessage(error);
  if (error is Map && error['message'] is String) {
    return _safeMessage(error['message'] as String);
  }

  final errors = data['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is String) return _safeMessage(value);
      if (value is List && value.isNotEmpty && value.first is String) {
        return _safeMessage(value.first as String);
      }
    }
  }

  return null;
}

String? _safeMessage(String message) {
  final text = message.trim();
  if (text.isEmpty || text.length > 500) return null;

  final lowercaseText = text.toLowerCase();
  if (lowercaseText.startsWith('<html') ||
      lowercaseText.startsWith('<!doctype html')) {
    return null;
  }

  return text;
}

int? _readCustomCode(Object? data) {
  if (data is! Map) return null;

  final code = data['customCode'] ?? data['custom_code'] ?? data['code'];

  if (code is int) return code;
  if (code is String) return int.tryParse(code);
  return null;
}
