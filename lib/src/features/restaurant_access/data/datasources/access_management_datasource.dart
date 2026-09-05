import '../../../../core/logging/operation_logger.dart';
import '../../../../core/services/network/supabase_service.dart';
import '../models/access_management_model.dart';

class AccessManagementDatasource {
  AccessManagementDatasource(this._service);
  final SupabaseService _service;

  Future<JoinInvitationModel?> resolveCode(String code) =>
      operationLogger.run('restaurant.join / resolve code', () async {
        final rows =
            await _service.supabaseClient.rpc(
                  'resolve_restaurant_join_code',
                  params: {'p_code': code},
                )
                as List;
        return rows.isEmpty
            ? null
            : JoinInvitationModel.fromJson(
                Map<String, dynamic>.from(rows.first as Map),
              );
      });

  Future<MembersAccessModel> getMembersAccess() =>
      operationLogger.run('restaurant.members / overview', () async {
        final result = await _service.supabaseClient.rpc(
          'get_restaurant_members_access',
        );
        // Restaurant RLS limits this query to the caller's restaurant.
        final restaurant = await operationLogger.run(
          'restaurant.profile / currency',
          () => _service.supabaseClient
              .from('restaurants')
              .select('currency_code')
              .single(),
        );
        return MembersAccessModel.fromJson({
          ...Map<String, dynamic>.from(result as Map),
          'currency_code': restaurant['currency_code'],
        });
      });

  Future<void> requestJoin(String code) =>
      _rpc('request_restaurant_join_by_code', {'p_code': code});
  Future<void> generateCode() => _rpc('generate_restaurant_join_code');
  Future<void> disableCode() => _rpc('disable_restaurant_join_code');
  Future<void> approve(String id) =>
      _rpc('approve_join_request', {'p_request_id': id});
  Future<void> decline(String id) =>
      _rpc('decline_join_request', {'p_request_id': id});
  Future<void> removeViewer(String id) =>
      _rpc('remove_restaurant_viewer', {'p_viewer_profile_id': id});
  Future<void> _rpc(String function, [Map<String, dynamic>? params]) =>
      operationLogger.run('restaurant.access / $function', () async {
        await _service.supabaseClient.rpc(function, params: params);
      });
}
