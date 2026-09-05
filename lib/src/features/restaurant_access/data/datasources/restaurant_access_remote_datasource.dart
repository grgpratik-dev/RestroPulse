import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/network/supabase_service.dart';
import '../../../../core/logging/operation_logger.dart';
import '../models/restaurant_access_model.dart';
import '../models/restaurant_join_request_model.dart';
import '../models/restaurant_membership_model.dart';

abstract class RestaurantAccessRemoteDatasource {
  Future<RestaurantAccessModel> getCurrentRestaurantAccess();
}

final class RestaurantAccessRemoteDatasourceImpl
    implements RestaurantAccessRemoteDatasource {
  RestaurantAccessRemoteDatasourceImpl(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<RestaurantAccessModel> getCurrentRestaurantAccess() async {
    final profileId = _supabaseService.currentUser?.id;
    if (profileId == null) {
      throw const AuthException(
        'User is not authenticated.',
        code: 'session_missing',
      );
    }

    // Step 1: Query restaurant_memberships for current user (authoritative under RLS)
    final membership = await operationLogger.run(
      'restaurant.access / select membership',
      () => _supabaseService.supabaseClient
          .from('restaurant_memberships')
          .select('restaurant_id, role')
          .eq('profile_id', profileId)
          .maybeSingle(),
    );

    if (membership != null) {
      return RestaurantAccessModel.hasRestaurant(
        membership: RestaurantMembershipModel.fromJson(membership),
      );
    }

    // Step 2: Query restaurant_join_requests for pending status
    final pendingRequest = await operationLogger.run(
      'restaurant.access / select pending join request',
      () => _supabaseService.supabaseClient
          .from('restaurant_join_requests')
          .select('id, restaurant_id, requester_profile_id, status, created_at')
          .eq('requester_profile_id', profileId)
          .eq('status', 'pending')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle(),
    );

    if (pendingRequest != null) {
      return RestaurantAccessModel.pendingJoinRequest(
        request: RestaurantJoinRequestModel.fromJson(pendingRequest),
      );
    }

    // Step 3: Neither membership nor pending request exists
    return const RestaurantAccessModel.noRestaurant();
  }
}
