import 'package:shared_preferences/shared_preferences.dart';

/// Stores non-sensitive values such as app settings and onboarding status.
class SharedPreferencesService {
  SharedPreferencesService(this._preferences);

  final SharedPreferencesAsync _preferences;

  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<bool?> getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  Future<int?> getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<void> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  Future<double?> getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Future<bool> containsKey(String key) {
    return _preferences.containsKey(key);
  }

  Future<void> remove(String key) {
    return _preferences.remove(key);
  }

  /// Clears only the supplied keys to avoid deleting preferences owned by
  /// plugins or native code.
  Future<void> clear(Set<String> keys) {
    return _preferences.clear(allowList: keys);
  }
}
