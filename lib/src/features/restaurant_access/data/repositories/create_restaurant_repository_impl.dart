import 'package:fpdart/fpdart.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/create_restaurant_datasource.dart';
import '../../domain/repositories/create_restaurant_repository.dart';

final class CreateRestaurantRepositoryImpl
    implements CreateRestaurantRepository {
  CreateRestaurantRepositoryImpl(this._datasource);
  final CreateRestaurantDatasource _datasource;

  @override
  Future<Either<Failure, String>> create({
    required String name,
    required String countryCode,
    required String currencyCode,
    required String address,
    required String phone,
  }) async {
    try {
      return Right(
        await _datasource.create(
          name: name,
          countryCode: countryCode,
          currencyCode: currencyCode,
          address: address,
          phone: phone,
        ),
      );
    } on PostgrestException catch (exception) {
      return Left(UnknownFailure(_creationFailureMessage(exception.code)));
    } on MissingPluginException {
      return const Left(
        UnknownFailure(
          'Device timezone is unavailable. Please restart the app and try again.',
        ),
      );
    } on PlatformException {
      return const Left(
        UnknownFailure(
          'Could not read your device timezone. Please check your device settings and try again.',
        ),
      );
    } on AuthException {
      return const Left(
        UnknownFailure('Your session has expired. Please sign in again.'),
      );
    } catch (_) {
      return const Left(
        UnknownFailure('Could not create your restaurant. Please try again.'),
      );
    }
  }

  String _creationFailureMessage(String? code) {
    return switch (code) {
      'PGRST202' || '42703' || '42883' =>
        'Restaurant setup is temporarily unavailable. Please contact support.',
      'PGRST301' => 'Your session has expired. Please sign in again.',
      '23503' =>
        'Your account setup is incomplete. Please contact support to finish setting up your profile.',
      '23505' =>
        'Restaurant setup conflicts with an existing record. Please check your restaurant access.',
      'P0001' =>
        'Restaurant setup could not be completed. Please check your restaurant access and setup details.',
      _ => 'Could not create your restaurant. Please try again.',
    };
  }

  @override
  Future<Either<Failure, Unit>> uploadLogo(
    String restaurantId,
    Uint8List bytes,
  ) async {
    try {
      await _datasource.uploadLogo(restaurantId, bytes);
      return const Right(unit);
    } catch (_) {
      return const Left(
        UnknownFailure(
          'Your restaurant was created, but the logo could not be saved. Retry or continue without it.',
        ),
      );
    }
  }
}
