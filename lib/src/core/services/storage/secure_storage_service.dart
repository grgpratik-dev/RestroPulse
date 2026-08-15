import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores sensitive string values such as access and refresh tokens.
class SecureStorageService {
  SecureStorageService(this._storage);

  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  /// Convenience methods used by REST authentication.
  ///
  /// Apps using Firebase ID tokens can ignore these helpers and read the
  /// current token from Firebase Authentication instead.
  Future<void> writeAccessToken(String token) {
    return write(_accessTokenKey, token);
  }

  Future<String?> readAccessToken() {
    return read(_accessTokenKey);
  }

  Future<void> deleteAccessToken() {
    return delete(_accessTokenKey);
  }

  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<bool> containsKey(String key) {
    return _storage.containsKey(key: key);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
