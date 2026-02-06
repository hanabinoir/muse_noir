import 'package:muse_noir/core/errors/app_exception.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// Error handler for converting exceptions to user-friendly messages
class ErrorHandler {
  ErrorHandler._();

  /// Convert exception to user-friendly message
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString();
    } else {
      return 'An unknown error occurred';
    }
  }

  /// Handle and log exception
  static void handleException(
    dynamic error, {
    StackTrace? stackTrace,
    String? tag,
  }) {
    final logger = AppLogger();

    if (error is AppException) {
      logger.error(
        '${tag ?? 'Error'}: ${error.message}',
        error: error.originalError,
        stackTrace: error.stackTrace ?? stackTrace,
      );
    } else if (error is Exception) {
      logger.error(
        '${tag ?? 'Error'}: $error',
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      logger.error(
        '${tag ?? 'Error'}: Unknown error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Wrap function with error handling
  static Future<T> tryCatch<T>(
    Future<T> Function() fn, {
    T? defaultValue,
    Function(dynamic error, StackTrace stackTrace)? onError,
    String? tag,
  }) async {
    try {
      return await fn();
    } catch (e, st) {
      handleException(e, stackTrace: st, tag: tag);
      onError?.call(e, st);
      if (defaultValue != null) {
        return defaultValue;
      }
      rethrow;
    }
  }
}

