import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/services/permissions/permission_service.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/core/providers/providers.dart';

/// State for permission status
enum PermissionStatus {
  notRequested,
  granted,
  denied,
  permanentlyDenied,
}

/// Notifier for managing media permission state
class PermissionNotifier extends Notifier<PermissionStatus> {
  late PermissionService _permissionService;
  final logger = AppLogger();

  @override
  PermissionStatus build() {
    _permissionService = ref.watch(permissionServiceProvider);
    return PermissionStatus.notRequested;
  }

  /// Check current permission status
  Future<void> checkPermission() async {
    try {
      final hasPermission = await _permissionService.hasMediaPermission();
      if (hasPermission) {
        state = PermissionStatus.granted;
        logger.info('Media permission is granted');
      } else {
        final isPermanentlyDenied =
            await _permissionService.isMediaPermissionPermanentlyDenied();
        if (isPermanentlyDenied) {
          state = PermissionStatus.permanentlyDenied;
          logger.info('Media permission is permanently denied');
        } else {
          state = PermissionStatus.denied;
          logger.info('Media permission is denied');
        }
      }
    } catch (e, stackTrace) {
      logger.error('Error checking permission: $e', error: e, stackTrace: stackTrace);
      state = PermissionStatus.denied;
    }
  }

  /// Request media permission
  Future<bool> requestPermission() async {
    try {
      logger.info('Requesting media permission');
      final granted = await _permissionService.requestMediaPermission();
      if (granted) {
        state = PermissionStatus.granted;
        logger.info('Media permission granted');
      } else {
        final isPermanentlyDenied =
            await _permissionService.isMediaPermissionPermanentlyDenied();
        state = isPermanentlyDenied
            ? PermissionStatus.permanentlyDenied
            : PermissionStatus.denied;
        logger.info('Media permission request denied');
      }
      return granted;
    } catch (e, stackTrace) {
      logger.error('Error requesting permission: $e', error: e, stackTrace: stackTrace);
      state = PermissionStatus.denied;
      return false;
    }
  }

  /// Open app settings
  Future<void> openSettings() async {
    try {
      logger.info('Opening app settings');
      await _permissionService.openAppSettings();
    } catch (e, stackTrace) {
      logger.error('Error opening settings: $e', error: e, stackTrace: stackTrace);
    }
  }
}

/// Notifier for managing notification permission state (Android 13+)
class NotificationPermissionNotifier extends Notifier<PermissionStatus> {
  late PermissionService _permissionService;
  final logger = AppLogger();

  @override
  PermissionStatus build() {
    _permissionService = ref.watch(permissionServiceProvider);
    return PermissionStatus.notRequested;
  }

  /// Check current notification permission status
  Future<void> checkPermission() async {
    try {
      final hasPermission = await _permissionService.hasNotificationPermission();
      if (hasPermission) {
        state = PermissionStatus.granted;
        logger.info('Notification permission is granted');
      } else {
        final isPermanentlyDenied =
            await _permissionService.isNotificationPermissionPermanentlyDenied();
        if (isPermanentlyDenied) {
          state = PermissionStatus.permanentlyDenied;
          logger.info('Notification permission is permanently denied');
        } else {
          state = PermissionStatus.denied;
          logger.info('Notification permission is denied');
        }
      }
    } catch (e, stackTrace) {
      logger.error('Error checking notification permission: $e', error: e, stackTrace: stackTrace);
      state = PermissionStatus.denied;
    }
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    try {
      logger.info('Requesting notification permission');
      final granted = await _permissionService.requestNotificationPermission();
      if (granted) {
        state = PermissionStatus.granted;
        logger.info('Notification permission granted');
      } else {
        final isPermanentlyDenied =
            await _permissionService.isNotificationPermissionPermanentlyDenied();
        state = isPermanentlyDenied
            ? PermissionStatus.permanentlyDenied
            : PermissionStatus.denied;
        logger.info('Notification permission request denied');
      }
      return granted;
    } catch (e, stackTrace) {
      logger.error('Error requesting notification permission: $e', error: e, stackTrace: stackTrace);
      state = PermissionStatus.denied;
      return false;
    }
  }

  /// Open app settings
  Future<void> openSettings() async {
    try {
      logger.info('Opening app settings');
      await _permissionService.openAppSettings();
    } catch (e, stackTrace) {
      logger.error('Error opening settings: $e', error: e, stackTrace: stackTrace);
    }
  }
}

