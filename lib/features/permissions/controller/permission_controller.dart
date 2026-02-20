import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

import '../state/permission_state.dart';

/// Controller for managing permission-related operations
class PermissionController {
  final Ref ref;
  final AppLogger _logger = AppLogger();

  PermissionController(this.ref);

  /// Check and get the current permission status
  Future<PermissionStatus> checkPermissionStatus() async {
    _logger.info('Checking permission status');
    final notifier = ref.read(permissionStatusProvider.notifier);
    await notifier.checkPermission();
    return ref.read(permissionStatusProvider);
  }

  /// Request permission from user
  Future<bool> requestPermission() async {
    _logger.info('Requesting permission from user');
    final notifier = ref.read(permissionStatusProvider.notifier);
    return await notifier.requestPermission();
  }

  /// Open app settings for manual permission management
  Future<void> openAppSettings() async {
    _logger.info('Opening app settings');
    final notifier = ref.read(permissionStatusProvider.notifier);
    await notifier.openSettings();
  }

  /// Check if permission is granted
  Future<bool> isPermissionGranted() async {
    final status = await checkPermissionStatus();
    return status == PermissionStatus.granted;
  }

  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    final status = await checkPermissionStatus();
    return status == PermissionStatus.permanentlyDenied;
  }

  /// Request permission and retry until granted or permanently denied
  /// Returns true if permission is granted, false otherwise
  Future<bool> requestPermissionWithRetry({int maxRetries = 1}) async {
    int retries = 0;
    while (retries <= maxRetries) {
      _logger.info('Permission request attempt ${retries + 1}');
      final granted = await requestPermission();
      if (granted) {
        _logger.info('Permission granted');
        return true;
      }

      final permanentlyDenied = await isPermissionPermanentlyDenied();
      if (permanentlyDenied) {
        _logger.warning('Permission permanently denied');
        return false;
      }

      retries++;
    }
    _logger.warning('Permission request failed after $maxRetries retries');
    return false;
  }
}

/// Provider for PermissionController
final permissionControllerProvider = Provider((ref) {
  return PermissionController(ref);
});

