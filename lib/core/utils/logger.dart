/// Simple logging utility for the app
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal();

  final bool _enableLogging = true;
  static const String _logTag = '[MuseNoir]';

  /// Log debug message
  void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    if (!_enableLogging) return;
    _log('DEBUG', message, error, stackTrace);
  }

  /// Log info message
  void info(String message, {dynamic error, StackTrace? stackTrace}) {
    if (!_enableLogging) return;
    _log('INFO', message, error, stackTrace);
  }

  /// Log warning message
  void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    if (!_enableLogging) return;
    _log('WARNING', message, error, stackTrace);
  }

  /// Log error message
  void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (!_enableLogging) return;
    _log('ERROR', message, error, stackTrace);
  }

  /// Internal logging method
  void _log(
    String level,
    String message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final buffer = StringBuffer();
    buffer.write('$_logTag [$level] $message');

    if (error != null) {
      buffer.write('\nError: $error');
    }

    if (stackTrace != null) {
      buffer.write('\nStackTrace: $stackTrace');
    }

    print(buffer.toString());
  }
}

