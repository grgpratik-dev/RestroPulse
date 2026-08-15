import 'package:equatable/equatable.dart';

import '../enums/enums.dart';
import 'api_exceptions.dart';
import 'firebase_exceptions.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, {this.statusCode, this.customCode});

  final String message;
  final int? statusCode;
  final int? customCode;

  @override
  List<Object?> get props => [message, statusCode, customCode];
}

class ApiFailure extends Failure {
  const ApiFailure(
    super.message, {
    required this.type,
    super.statusCode,
    super.customCode,
  });

  factory ApiFailure.fromException(ApiException exception) {
    return ApiFailure(
      exception.message,
      type: exception.type,
      statusCode: exception.statusCode,
      customCode: exception.customCode,
    );
  }

  final ApiErrorType type;

  @override
  List<Object?> get props => [...super.props, type];
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(
    super.message, {
    required this.type,
    required this.code,
    this.plugin,
  });

  factory FirebaseFailure.fromException(AppFirebaseException exception) {
    return FirebaseFailure(
      exception.message,
      type: exception.type,
      code: exception.code,
      plugin: exception.plugin,
    );
  }

  final FirebaseErrorType type;
  final String code;
  final String? plugin;

  @override
  List<Object?> get props => [...super.props, type, code, plugin];
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
