import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:muse_noir/core/errors/app_exception.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// Service for handling permissions related to media access
class PermissionService {
  final AppLogger _logger = AppLogger();

  /// Check if READ_MEDIA_AUDIO permission is granted
  /// Falls back to READ_EXTERNAL_STORAGE for older Android versions
  Future<bool> hasMediaPermission() async {
    try {
      final status = await permission_handler.Permission.audio.status;
      return status.isGranted;
    } catch (e) {
      _logger.error('Error checking media permission: $e');
      return false;
    }
  }

  /// Request READ_MEDIA_AUDIO permission
  /// Falls back to READ_EXTERNAL_STORAGE for older Android versions
  Future<bool> requestMediaPermission() async {
    try {
      final status = await permission_handler.Permission.audio.request();
      _logger.info('Media permission request result: ${status.name}');
      return status.isGranted;
    } catch (e) {
      throw PermissionException(message: 'Failed to request media permission: $e');
    }
  }

  /// Check if permission is permanently denied
  Future<bool> isMediaPermissionDenied() async {
    try {
      final status = await permission_handler.Permission.audio.status;
      return status.isDenied;
    } catch (e) {
      _logger.error('Error checking media permission status: $e');
      return false;
    }
  }

  /// Check if permission is permanently denied and cannot be requested again
  Future<bool> isMediaPermissionPermanentlyDenied() async {
    try {
      final status = await permission_handler.Permission.audio.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      _logger.error('Error checking permanent denial status: $e');
      return false;
    }
  }

  /// Open app settings to allow user to manually enable permission
  Future<void> openAppSettings() async {
    try {
      await permission_handler.openAppSettings();
    } catch (e) {
      throw PermissionException(message: 'Failed to open app settings: $e');
    }
  }

  /// Open app settings to allow user to manually enable permission (alternative name)
  Future<void> openPermissionSettings() async {
    try {
      await permission_handler.openAppSettings();
    } catch (e) {
      throw PermissionException(message: 'Failed to open app settings: $e');
    }
  }

  /// Request all necessary permissions for media playback
  /// Returns true if all required permissions are granted
  Future<bool> requestAllMediaPermissions() async {
    try {
      // Request both audio and storage permissions as fallback
      final audioStatus = await permission_handler.Permission.audio.request();
      final storageStatus = await permission_handler.Permission.storage.request();

      _logger.info(
        'Permissions - Audio: ${audioStatus.name}, Storage: ${storageStatus.name}',
      );

      return audioStatus.isGranted || storageStatus.isGranted;
    } catch (e) {
      throw PermissionException(message: 'Failed to request permissions: $e');
    }
  }

  /// Check if all required permissions are granted
  Future<bool> hasAllMediaPermissions() async {
    try {
      final audioStatus = await permission_handler.Permission.audio.status;
      final storageStatus = await permission_handler.Permission.storage.status;

      return audioStatus.isGranted || storageStatus.isGranted;
    } catch (e) {
      _logger.error('Error checking all permissions: $e');
      return false;
    }
  }

  /// Get current permission status as string for logging/debugging
  Future<String> getPermissionStatus() async {
    try {
      final audioStatus = await permission_handler.Permission.audio.status;
      final storageStatus = await permission_handler.Permission.storage.status;

      return 'Audio: ${audioStatus.name}, Storage: ${storageStatus.name}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}




