import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

/// Dio request metadata used by authentication-related interceptors.
const requiresAuthKey = 'requiresAuth';

/// Adds the stored bearer token only to requests that require authentication.
final class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra[requiresAuthKey] == true;
    final alreadyHasToken = options.headers.containsKey('Authorization');

    if (!requiresAuth || alreadyHasToken) {
      handler.next(options);
      return;
    }

    try {
      final token = await _secureStorage.readAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } on Exception catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
          message: 'The access token could not be read.',
        ),
      );
    }
  }
}
