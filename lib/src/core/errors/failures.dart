import 'package:equatable/equatable.dart';

import '../enums/enums.dart';
import 'api_exceptions.dart';

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

/// Supabase failure
class SupabaseFailure extends Failure {
  const SupabaseFailure(
    super.message, {
    this.supabaseCode,
    this.supabaseStatusCode,
  });

  final String? supabaseCode;
  final String? supabaseStatusCode;

  @override
  List<Object?> get props => [...super.props, supabaseCode, supabaseStatusCode];
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
