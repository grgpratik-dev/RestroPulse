import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_logger.dart';

/// Traces operations without recording request bodies, tokens, or responses.
final class OperationLogger {
  OperationLogger(this._logger);

  final AppLogger _logger;
  int _sequence = 0;

  Future<T> run<T>(String operation, Future<T> Function() action) async {
    if (!kDebugMode) return action();
    final label = '$operation #${++_sequence}';
    final timer = Stopwatch()..start();
    _logger.log(message: '[$label] START');
    try {
      final result = await action();
      _logger.log(message: '[$label] OK (${timer.elapsedMilliseconds} ms)');
      return result;
    } catch (error, stackTrace) {
      final diagnostic = switch (error) {
        PostgrestException() =>
          'PostgrestException code=${error.code}. ${_databaseHint(error.code)}${_safeDatabaseMessage(error)}',
        AuthException() =>
          'AuthException code=${error.code} status=${error.statusCode}',
        StorageException() => 'StorageException status=${error.statusCode}',
        MissingPluginException() =>
          'MissingPluginException: native plugin unavailable; stop and rebuild the app (hot reload is insufficient).',
        PlatformException() => 'PlatformException code=${error.code}',
        _ => error.runtimeType.toString(),
      };
      _logger.log(
        message: '[$label] FAILED (${timer.elapsedMilliseconds} ms)',
        loggerLevel: LoggerLevel.error,
        error: diagnostic,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String _safeDatabaseMessage(PostgrestException error) {
    if (error.code == '23503') {
      // PostgreSQL's primary FK message contains table/constraint names.
      // Its details contain row values and must remain excluded.
      final match = RegExp(
        r'^insert or update on table "([A-Za-z0-9_]+)" violates foreign key constraint "([A-Za-z0-9_]+)"$',
      ).firstMatch(error.message);
      return match == null
          ? ''
          : ' Table=${match.group(1)} constraint=${match.group(2)}';
    }
    // These errors describe schema identifiers rather than submitted row values.
    if (const {'PGRST202', '42703', '42883'}.contains(error.code)) {
      return ' ${error.message}';
    }
    const setupErrors = {
      'Authentication required',
      'Restaurant name is required',
      'Country code is required',
      'Currency code is required',
      'Timezone is required',
      'User already belongs to a restaurant',
      'Invalid timezone',
      'Invalid country code',
      'Invalid currency code',
    };
    return setupErrors.contains(error.message) ? ' ${error.message}' : '';
  }

  String _databaseHint(String? code) => switch (code) {
    'PGRST202' =>
      'RPC signature missing from schema cache. Check deployed function parameters and migrations.',
    '42703' => 'Undefined database column. Check deployed table schema.',
    '42883' => 'Undefined database function. Check deployed migrations.',
    '42501' =>
      'Insufficient privileges. Check authentication, grants, and RLS.',
    '23503' =>
      'Foreign key violation. Check required profile and related records.',
    '23505' => 'Unique constraint violation. Check existing membership.',
    'P0001' =>
      'Database function rejected the operation with a business-rule exception.',
    'PGRST301' => 'Invalid or expired authentication token.',
    _ => 'Inspect the database logs for this error code.',
  };
}

final operationLogger = OperationLogger(appLogger);
