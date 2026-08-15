import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../app/config/api_config.dart';
import '../../errors/api_exceptions.dart';
import '../session/session_service.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/authorization_interceptor.dart';
import 'interceptors/network_logging_interceptor.dart';
import 'interceptors/session_interceptor.dart';

/// Sends REST API requests through Dio.
///
/// Every request follows the same simple flow:
/// 1. Read the access token when authorization is required.
/// 2. Send the request with Dio.
/// 3. Return the typed response on success.
/// 4. Convert Dio errors into ApiException.
final class NetworkService {
  NetworkService({
    required ApiConfig config,
    required SecureStorageService secureStorage,
    required SessionService sessionService,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      sendTimeout: config.sendTimeout,
      receiveTimeout: config.receiveTimeout,
      receiveDataWhenStatusError: true,
      headers: const {Headers.acceptHeader: Headers.jsonContentType},
    );

    _dio.interceptors.add(AuthorizationInterceptor(secureStorage));
    _dio.interceptors.add(SessionInterceptor(sessionService));

    // Keep logging last so it sees changes made by the other interceptors.
    if (kDebugMode) {
      _dio.interceptors.add(NetworkLoggingInterceptor());
    }
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );
  }

  /// Executes the actual request used by all methods above.
  ///
  /// Pass [FormData] as [data] for uploads. Use [responseType] when downloading
  /// bytes or plain text instead of JSON.
  Future<Response<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelToken? cancelToken,
    ResponseType? responseType,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          method: method,
          // Dio copies these request-specific headers into RequestOptions.
          headers: headers,
          responseType: responseType,
          extra: {requiresAuthKey: requiresAuth},
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on Exception catch (error, stackTrace) {
      throw ApiException.from(error, stackTrace: stackTrace);
    }
  }
}
