
/// Custom exceptions for the app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception for permission-related errors
class PermissionException extends AppException {
  PermissionException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'PERMISSION_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Exception for audio playback errors
class AudioPlaybackException extends AppException {
  AudioPlaybackException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'AUDIO_PLAYBACK_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Exception for file/media not found errors
class FileNotFoundException extends AppException {
  FileNotFoundException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'FILE_NOT_FOUND',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Exception for media scanning errors
class MediaScanException extends AppException {
  MediaScanException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'MEDIA_SCAN_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Exception for database/storage errors
class StorageException extends AppException {
  StorageException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'STORAGE_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'NETWORK_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Generic exception for unhandled errors
class UnknownException extends AppException {
  UnknownException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'UNKNOWN_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

