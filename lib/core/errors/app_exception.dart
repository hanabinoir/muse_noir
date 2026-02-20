
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
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'PERMISSION_ERROR',
  );
}

/// Exception for audio playback errors
class AudioPlaybackException extends AppException {
  AudioPlaybackException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'AUDIO_PLAYBACK_ERROR',
  );
}

/// Exception for file/media not found errors
class FileNotFoundException extends AppException {
  FileNotFoundException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'FILE_NOT_FOUND',
  );
}

/// Exception for media scanning errors
class MediaScanException extends AppException {
  MediaScanException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'MEDIA_SCAN_ERROR',
  );
}

/// Exception for database/storage errors
class StorageException extends AppException {
  StorageException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'STORAGE_ERROR',
  );
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'NETWORK_ERROR',
  );
}

/// Generic exception for unhandled errors
class UnknownException extends AppException {
  UnknownException({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(
    code: code ?? 'UNKNOWN_ERROR',
  );
}

