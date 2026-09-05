import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:restropulse/src/core/logging/app_logger.dart';
import 'package:restropulse/src/core/logging/operation_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late List<LogEvent> events;
  late OperationLogger logger;
  late void Function(LogEvent) listener;

  setUp(() {
    events = [];
    listener = events.add;
    Logger.addLogListener(listener);
    logger = OperationLogger(AppLogger());
  });
  tearDown(() => Logger.removeLogListener(listener));

  test('logs operation lifecycle without logging the returned data', () async {
    final result = await logger.run(
      'create RPC',
      () async => 'private response',
    );
    expect(result, 'private response');
    expect(events.map((event) => event.message).join(), contains('START'));
    expect(events.last.message, contains('OK'));
    expect(
      events.map((event) => event.message).join(),
      isNot(contains(result)),
    );
  });

  test(
    'preserves exceptions and logs code and stack without row details',
    () async {
      const error = PostgrestException(
        code: '23505',
        message: 'private submitted value',
        details: 'private row contents',
      );
      await expectLater(
        logger.run('create RPC', () async => throw error),
        throwsA(same(error)),
      );
      expect(events.last.message, contains('FAILED'));
      expect(events.last.error.toString(), contains('23505'));
      expect(events.last.error.toString(), isNot(contains('private')));
      expect(events.last.stackTrace, isNotNull);
    },
  );

  test('identifies native plugin failure before the RPC', () async {
    final error = MissingPluginException('unavailable');
    await expectLater(
      logger.run('device timezone', () async => throw error),
      throwsA(same(error)),
    );
    expect(events.last.message, contains('device timezone'));
    expect(events.last.error.toString(), contains('stop and rebuild'));
  });

  test('logs FK constraint names without exposing missing row values', () async {
    const error = PostgrestException(
      code: '23503',
      message:
          'insert or update on table "restaurant_memberships" violates foreign key constraint "restaurant_memberships_profile_id_fkey"',
      details:
          'Key (profile_id)=(private-user-id) is not present in table "profiles".',
    );
    await expectLater(
      logger.run('create RPC', () async => throw error),
      throwsA(same(error)),
    );
    expect(
      events.last.error.toString(),
      contains('restaurant_memberships_profile_id_fkey'),
    );
    expect(events.last.error.toString(), isNot(contains('private-user-id')));
  });
}
