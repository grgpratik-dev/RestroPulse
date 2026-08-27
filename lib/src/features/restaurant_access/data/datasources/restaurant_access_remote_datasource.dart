import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/network/supabase_service.dart';
import '../models/restaurant_access_model.dart';

abstract class RestaurantAccessRemoteDatasource {
  Future<RestaurantAccessModel?> getCurrentRestaurantAccess();
}

final class RestaurantAccessRemoteDatasourceImpl
    implements RestaurantAccessRemoteDatasource {
  RestaurantAccessRemoteDatasourceImpl(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<RestaurantAccessModel?> getCurrentRestaurantAccess() async {
    final profileId = _supabaseService.currentUser?.id;
    if (profileId == null) {
      throw AuthSessionMissingException();
    }

    final membership = await _supabaseService.supabaseClient
        .from('restaurant_memberships')
        .select('restaurant_id, role')
        .eq('profile_id', profileId)
        .maybeSingle();

    if (membership != null) {
      return RestaurantAccessModel.fromJson(membership);
    }

    final pendingRequest = await _supabaseService.supabaseClient
        .from('restaurant_join_requests')
        .select('restaurant_id, status')
        .eq('requester_profile_id', profileId)
        .eq('status', 'pending')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return pendingRequest == null
        ? null
        : RestaurantAccessModel.fromJson(pendingRequest);
  }
}
