import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/bloc/image_picker/image_picker_bloc.dart';
import '../../core/services/media/image_picker_service.dart';
import '../../core/services/network/network_service.dart';
import '../../core/services/session/session_service.dart';
import '../../core/services/storage/secure_storage_service.dart';
import '../../core/services/storage/shared_preferences_service.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../bloc/app_bloc.dart';
import '../config/api_config.dart';

// create global get_it(service locator) instance
final sl = GetIt.instance;

void initGetIt() {
  // Register your dependencies here
  // Example:
  // sl.registerLazySingleton<YourService>(() => YourServiceImpl());

  serviceDependencies();
  datasourceDependencies();
  repositoryDependencies();
  usecaseDependencies();
  blocDependencies();
}

// grouping dependencies based on service, datasource, repository, usecase, bloc.

void serviceDependencies() {
  sl.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(ImagePicker()),
  );
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(SharedPreferencesAsync()),
  );
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(const FlutterSecureStorage()),
  );
  sl.registerLazySingleton<SessionService>(
    () => SessionService(sl<SecureStorageService>()),
    dispose: (service) => service.dispose(),
  );

  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(
      config: restApiConfig,
      secureStorage: sl<SecureStorageService>(),
      sessionService: sl<SessionService>(),
    ),
  );
}

void datasourceDependencies() {
  // Register your datasource dependencies here
}

void repositoryDependencies() {
  // Register your repository dependencies here
}

void usecaseDependencies() {
  // Register your usecase dependencies here
}

void blocDependencies() {
  // Register your bloc dependencies here
  sl.registerFactory<AppBloc>(() => AppBloc(sl<SessionService>()));
  sl.registerFactory<ImagePickerBloc>(
    () => ImagePickerBloc(sl<ImagePickerService>()),
  );
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc());
}
