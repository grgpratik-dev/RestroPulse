import 'package:restropulse/src/features/restaurant_access/data/datasources/access_management_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/access_management_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/access_management_repository.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/join_restaurant/join_restaurant_cubit.dart';
import 'package:restropulse/src/features/profile/presentation/cubits/members_access/members_access_cubit.dart';
import 'package:restropulse/src/features/restaurant_access/data/datasources/create_restaurant_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/create_restaurant_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/create_restaurant_repository.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/create_restaurant/create_restaurant_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/country_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/country_repository.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/choose_country/choose_country_cubit.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/restaurant_access/restaurant_access_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restropulse/src/app/session/app_session_controller.dart';
import 'package:restropulse/src/core/services/network/google_service.dart';
import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:restropulse/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:restropulse/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_out/sign_out_cubit.dart';
import 'package:restropulse/src/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/datasources/restaurant_access_remote_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/restaurant_access_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/restaurant_access_repository.dart';
import 'package:restropulse/src/features/restaurant_access/domain/usecases/get_current_restaurant_access_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/bloc/image_picker/image_picker_bloc.dart';
import '../../core/services/media/image_picker_service.dart';
import '../../core/services/storage/secure_storage_service.dart';
import '../../core/services/storage/shared_preferences_service.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

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
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
  sl.registerLazySingleton<GoogleService>(() => GoogleService());

  sl.registerLazySingleton<AppSessionController>(
    () => AppSessionController(
      supabaseService: sl(),
      onboardingLocalDataSource: sl(),
      getCurrentRestaurantAccess: sl(),
    ),
  );

  sl.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(ImagePicker()),
  );
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(SharedPreferencesAsync()),
  );
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(const FlutterSecureStorage()),
  );
}

void datasourceDependencies() {
  sl.registerLazySingleton<AccessManagementDatasource>(
    () => AccessManagementDatasource(sl()),
  );
  sl.registerLazySingleton<CreateRestaurantDatasource>(
    () => CreateRestaurantDatasource(sl()),
  );
  // Register your datasource dependencies here
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RestaurantAccessRemoteDatasource>(
    () => RestaurantAccessRemoteDatasourceImpl(sl()),
  );
}

void repositoryDependencies() {
  sl.registerLazySingleton<AccessManagementRepository>(
    () => AccessManagementRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CreateRestaurantRepository>(
    () => CreateRestaurantRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(rootBundle),
  );
  // Register your repository dependencies here
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RestaurantAccessRepository>(
    () => RestaurantAccessRepositoryImpl(sl()),
  );
}

void usecaseDependencies() {
  // Register your usecase dependencies here
  sl.registerLazySingleton<RequestOtpUsecase>(() => RequestOtpUsecase(sl()));

  sl.registerLazySingleton<VerifyOtpUsecase>(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton<SignOutUsecase>(() => SignOutUsecase(sl()));
  sl.registerLazySingleton<SignInWithGoogleUsecase>(
    () => SignInWithGoogleUsecase(sl()),
  );
  sl.registerLazySingleton<GetCurrentRestaurantAccessUsecase>(
    () => GetCurrentRestaurantAccessUsecase(sl()),
  );
}

void blocDependencies() {
  sl.registerFactory<JoinRestaurantCubit>(() => JoinRestaurantCubit(sl()));
  sl.registerFactory<MembersAccessCubit>(() => MembersAccessCubit(sl()));
  sl.registerFactory<CreateRestaurantCubit>(() => CreateRestaurantCubit(sl()));
  sl.registerFactory<ChooseCountryCubit>(() => ChooseCountryCubit(sl()));
  // Register your bloc dependencies here

  sl.registerFactory<ImagePickerBloc>(
    () => ImagePickerBloc(sl<ImagePickerService>()),
  );
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc());

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory<SignOutCubit>(() => SignOutCubit(sl()));
  sl.registerFactory<RestaurantAccessCubit>(() => RestaurantAccessCubit(sl()));
}
