import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restropulse/src/core/enums/enums.dart';
import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';

final class AppSessionController extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final OnboardingLocalDataSource _onboardingLocalDataSource;

  AppSessionController({
    required SupabaseService supabaseService,
    required OnboardingLocalDataSource onboardingLocalDataSource,
  }) : _supabaseService = supabaseService,
       _onboardingLocalDataSource = onboardingLocalDataSource;

  AppStatus _status = AppStatus.initializing;

  AppStatus get status => _status;

  bool _hasCompletedOnboarding = false;

  StreamSubscription<AuthState>? _authSubscription;

  Future<void> initialize() async {
    _hasCompletedOnboarding = await _onboardingLocalDataSource
        .hasCompletedOnboarding();

    _listenToAuthChanges();

    if (!_hasCompletedOnboarding) {
      _setStatus(AppStatus.onboarding);
      return;
    }

    _setStatus(
      _supabaseService.isAuthenticated
          ? AppStatus.authenticated
          : AppStatus.unauthenticated,
    );
  }

  Future<void> completeOnboarding() async {
    await _onboardingLocalDataSource.completeOnboarding();

    _hasCompletedOnboarding = true;

    _setStatus(
      _supabaseService.isAuthenticated
          ? AppStatus.authenticated
          : AppStatus.unauthenticated,
    );
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();

    _authSubscription = _supabaseService.authStateChanges.listen((authState) {
      // Don't leave onboarding just because
      // Supabase emits an auth event.
      if (!_hasCompletedOnboarding) {
        return;
      }

      final session = authState.session;

      _setStatus(
        session != null ? AppStatus.authenticated : AppStatus.unauthenticated,
      );
    });
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
    _authSubscription?.cancel();
    super.dispose();
  }
}
