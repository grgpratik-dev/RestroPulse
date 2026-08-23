import 'package:dio/dio.dart';

import '../supabase_service.dart';

/// Dio request metadata used by authentication-related interceptors.
const requiresAuthKey = 'requiresAuth';

/// Adds the current Supabase bearer token to authenticated requests.
final class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._authService);

  final SupabaseService _authService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresAuth = options.extra[requiresAuthKey] == true;
    final alreadyHasToken = options.headers.containsKey('Authorization');

    if (!requiresAuth || alreadyHasToken) {
      handler.next(options);
      return;
    }

    final token = _authService.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
