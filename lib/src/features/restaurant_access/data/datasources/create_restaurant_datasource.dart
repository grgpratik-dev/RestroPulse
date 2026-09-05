import 'dart:typed_data';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/network/supabase_service.dart';
import '../../../../core/logging/operation_logger.dart';

class CreateRestaurantDatasource {
  CreateRestaurantDatasource(this._service);
  final SupabaseService _service;
  Future<String> create({
    required String name,
    required String countryCode,
    required String currencyCode,
    required String address,
    required String phone,
  }) async {
    final timezone = await operationLogger.run(
      'restaurant.create / device timezone',
      FlutterTimezone.getLocalTimezone,
    );
    return operationLogger.run(
      'restaurant.create / RPC create_restaurant',
      () async {
        final id = await _service.supabaseClient.rpc(
          'create_restaurant',
          params: {
            'p_name': name.trim(),
            'p_country_code': countryCode,
            'p_currency_code': currencyCode,
            'p_timezone': timezone.identifier,
            'p_address': address.trim(),
            'p_phone': phone.trim().isEmpty ? null : phone.trim(),
          },
        );
        return id as String;
      },
    );
  }

  Future<void> uploadLogo(String restaurantId, Uint8List bytes) async {
    final path = '$restaurantId/logo.png';
    await operationLogger.run(
      'restaurant.logo / storage upload',
      () => _service.supabaseClient.storage
          .from('restaurant-logos')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/png',
            ),
          ),
    );
    await operationLogger.run(
      'restaurant.logo / update restaurants.logo_path',
      () => _service.supabaseClient
          .from('restaurants')
          .update({'logo_path': path})
          .eq('id', restaurantId),
    );
  }
}
