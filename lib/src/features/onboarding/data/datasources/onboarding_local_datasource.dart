import 'package:restropulse/src/core/services/storage/shared_preferences_service.dart';

import '../../../../core/constants/storage_keys.dart';

abstract interface class OnboardingLocalDataSource {
  Future<bool> hasCompletedOnboarding();

  Future<void> completeOnboarding();
}

final class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferencesService _sharedPreferencesService;

  OnboardingLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<bool> hasCompletedOnboarding() async {
    final result = await _sharedPreferencesService.getBool(
      StorageKeys.hasCompletedOnboarding,
    );

    return result ?? false;
  }

  @override
  Future<void> completeOnboarding() {
    return _sharedPreferencesService.setBool(
      StorageKeys.hasCompletedOnboarding,
      true,
    );
  }
}
