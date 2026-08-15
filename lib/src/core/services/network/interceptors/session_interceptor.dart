import 'package:dio/dio.dart';

import '../../session/session_service.dart';
import 'authorization_interceptor.dart';

/// Expires the global session when an authenticated request returns HTTP 401.
final class SessionInterceptor extends Interceptor {
  SessionInterceptor(this._sessionService);

  final SessionService _sessionService;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requiresAuth = err.requestOptions.extra[requiresAuthKey] == true;
    final isUnauthorized = err.response?.statusCode == 401;

    // A public endpoint such as login may also return 401. Only authenticated
    // requests are allowed to expire the application's current session.
    if (requiresAuth && isUnauthorized) {
      await _sessionService.expireSession();
    }

    // Continue the error flow so NetworkService can create an ApiException.
    handler.next(err);
  }
}
