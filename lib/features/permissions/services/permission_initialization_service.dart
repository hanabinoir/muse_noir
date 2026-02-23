import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

import '../state/permission_state.dart';

/// Service for initializing permissions on app startup
class PermissionInitializationService {
  final Ref ref;
  final AppLogger _logger = AppLogger();

  PermissionInitializationService(this.ref);

  /// Initialize permissions on app startup
  /// Returns true if critical permissions are granted
  Future<bool> initializePermissions() async {
    try {
      _logger.info('Initializing permissions on app startup');

      // Check media permission status (critical)
      final mediaNotifier = ref.read(permissionStatusProvider.notifier);
      await mediaNotifier.checkPermission();

      final mediaStatus = ref.read(permissionStatusProvider);
      _logger.info('Media permission status: ${mediaStatus.name}');

      // Check notification permission status (important for lock screen)
      final notificationNotifier = ref.read(notificationPermissionStatusProvider.notifier);
      await notificationNotifier.checkPermission();

      final notificationStatus = ref.read(notificationPermissionStatusProvider);
      _logger.info('Notification permission status: ${notificationStatus.name}');

      // Return true if media permission is granted (critical requirement)
      if (mediaStatus == PermissionStatus.granted) {
        _logger.info('Media permission already granted');
        // Notification permission is secondary - nice to have for lock screen
        return true;
      }

      // If media permission is permanently denied, log warning but don't crash
      if (mediaStatus == PermissionStatus.permanentlyDenied) {
        _logger.warning('Media permission permanently denied, user must enable in settings');
        return false;
      }

      // Media permission not yet requested
      _logger.info('Media permission not yet requested');
      return false;
    } catch (e, stackTrace) {
      _logger.error(
        'Error during permission initialization',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Check if media permissions need to be requested
  Future<bool> shouldRequestMediaPermission() async {
    final status = ref.read(permissionStatusProvider);
    return status == PermissionStatus.notRequested || status == PermissionStatus.denied;
  }

  /// Check if notification permissions need to be requested
  Future<bool> shouldRequestNotificationPermission() async {
    final status = ref.read(notificationPermissionStatusProvider);
    return status == PermissionStatus.notRequested || status == PermissionStatus.denied;
  }

  /// Initialize notification permission specifically
  /// This ensures lock screen notifications work properly
  Future<bool> initializeNotificationPermission() async {
    try {
      _logger.info('Initializing notification permission');
      final notifier = ref.read(notificationPermissionStatusProvider.notifier);
      await notifier.checkPermission();

      final status = ref.read(notificationPermissionStatusProvider);
      _logger.info('Notification permission status: ${status.name}');

      return status == PermissionStatus.granted;
    } catch (e, stackTrace) {
      _logger.error(
        'Error during notification permission initialization',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}

/// Provider for PermissionInitializationService
final permissionInitServiceProvider = Provider((ref) {
  return PermissionInitializationService(ref);
});

