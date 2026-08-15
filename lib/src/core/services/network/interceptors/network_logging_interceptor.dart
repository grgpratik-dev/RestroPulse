import 'package:dio/dio.dart';

import '../../../logging/app_logger.dart';

/// Prints complete Dio request, response, and error details during development.
///
/// NetworkService only registers this interceptor in debug builds because its
/// output can contain access tokens and other sensitive information.
final class NetworkLoggingInterceptor extends LogInterceptor {
  NetworkLoggingInterceptor()
    : super(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (message) => appLogger.console(message.toString()),
      );
}
