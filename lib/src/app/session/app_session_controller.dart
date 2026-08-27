import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restropulse/src/core/enums/enums.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';
import 'package:restropulse/src/features/restaurant_access/domain/usecases/get_current_restaurant_access_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';

final class AppSessionController extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final OnboardingLocalDataSource _onboardingLocalDataSource;
  final GetCurrentRestaurantAccessUsecase _getCurrentRestaurantAccess;

  AppSessionController({
    required SupabaseService supabaseService,
    required OnboardingLocalDataSource onboardingLocalDataSource,
    required GetCurrentRestaurantAccessUsecase getCurrentRestaurantAccess,
  }) : _supabaseService = supabaseService,
       _onboardingLocalDataSource = onboardingLocalDataSource,
       _getCurrentRestaurantAccess = getCurrentRestaurantAccess;

  AppStatus _status = AppStatus.initializing;

  AppStatus get status => _status;

  RestaurantAccess? _restaurantAccess;

  RestaurantAccess? get restaurantAccess => _restaurantAccess;

  Failure? _restaurantAccessFailure;

  Failure? get restaurantAccessFailure => _restaurantAccessFailure;

  bool _hasCompletedOnboarding = false;

  StreamSubscription<AuthState>? _authSubscription;
  String? _resolvingProfileId;
  String? _resolvedProfileId;
  int _resolutionVersion = 0;
  bool _isDisposed = false;

  Future<void> initialize() async {
    _hasCompletedOnboarding = await _onboardingLocalDataSource
        .hasCompletedOnboarding();

    _listenToAuthChanges();

    if (!_hasCompletedOnboarding) {
      _setStatus(AppStatus.onboarding);
      return;
    }

    await _resolveCurrentSession();
  }

  Future<void> completeOnboarding() async {
    await _onboardingLocalDataSource.completeOnboarding();

    _hasCompletedOnboarding = true;

    await _resolveCurrentSession();
  }

  Future<void> refreshRestaurantAccess() {
    return _resolveCurrentSession(force: true);
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();

    _authSubscription = _supabaseService.authStateChanges.listen((authState) {
      // Don't leave onboarding just because
      // Supabase emits an auth event.
      if (!_hasCompletedOnboarding) {
        return;
      }

      unawaited(_handleAuthSession(authState.session));
    });
  }

  Future<void> _resolveCurrentSession({bool force = false}) {
    return _handleAuthSession(_supabaseService.currentSession, force: force);
  }

  Future<void> _handleAuthSession(
    Session? session, {
    bool force = false,
  }) async {
    if (!_hasCompletedOnboarding) return;

    if (session == null) {
      _resolutionVersion++;
      _resolvingProfileId = null;
      _resolvedProfileId = null;
      _restaurantAccess = null;
      _restaurantAccessFailure = null;
      _setStatus(AppStatus.unauthenticated);
      return;
    }

    final profileId = session.user.id;
    if (!force && _resolvingProfileId == profileId) return;
    if (!force && _resolvedProfileId == profileId) return;

    final resolutionVersion = ++_resolutionVersion;
    _resolvingProfileId = profileId;
    _restaurantAccess = null;
    _restaurantAccessFailure = null;
    _setStatus(AppStatus.checkingRestaurantAccess);

    final result = await _getCurrentRestaurantAccess(NoParams());
    if (_isDisposed || resolutionVersion != _resolutionVersion) return;
    if (_supabaseService.currentUser?.id != profileId) return;

    _resolvingProfileId = null;
    _resolvedProfileId = profileId;

    result.fold(
      (failure) {
        _restaurantAccessFailure = failure;
        _setStatus(AppStatus.restaurantAccessFailure);
      },
      (access) {
        _restaurantAccess = access;
        _setStatus(switch (access?.type) {
          RestaurantAccessType.active => AppStatus.hasRestaurantAccess,
          RestaurantAccessType.pending => AppStatus.restaurantAccessPending,
          null => AppStatus.noRestaurantAccess,
        });
      },
    );
  }

  void _setStatus(AppStatus newStatus) {
    if (_status == newStatus) {
      return;
    }

    _status = newStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _resolutionVersion++;
    _authSubscription?.cancel();
    super.dispose();
  }
}
