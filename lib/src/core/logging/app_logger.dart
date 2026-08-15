import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LoggerLevel { debug, info, warning, error, fatal }

final appLogger = AppLogger();

final class AppLogger {
  final _logger = Logger(printer: PrettyPrinter());

  void log({
    required final String message,
    final LoggerLevel loggerLevel = LoggerLevel.info,
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    switch (loggerLevel) {
      case LoggerLevel.debug:
        _logger.d(message, error: error, stackTrace: stackTrace);
        break;
      case LoggerLevel.info:
        _logger.i(message, error: error, stackTrace: stackTrace);
        break;
      case LoggerLevel.warning:
        _logger.w(message, error: error, stackTrace: stackTrace);
        break;
      case LoggerLevel.error:
        _logger.e(message, error: error, stackTrace: stackTrace);
        break;
      case LoggerLevel.fatal:
        _logger.f(message, error: error, stackTrace: stackTrace);
        break;
    }
  }

  // simple console function for quick logging during development, only prints messages in debug mode.
  void console(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
