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
  /// Returns true if permissions are granted, false if user action is required
  Future<bool> initializePermissions() async {
    try {
      _logger.info('Initializing permissions on app startup');

      // Check current permission status
      final notifier = ref.read(permissionStatusProvider.notifier);
      await notifier.checkPermission();

      final status = ref.read(permissionStatusProvider);
      _logger.info('Initial permission status: ${status.name}');

      // Return true if permission is already granted
      if (status == PermissionStatus.granted) {
        _logger.info('Permission already granted');
        return true;
      }

      // If permanently denied, log warning but don't crash
      if (status == PermissionStatus.permanentlyDenied) {
        _logger.warning('Permission permanently denied, user must enable in settings');
        return false;
      }

      // Permission not yet requested
      _logger.info('Permission not yet requested');
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

  /// Check if permissions need to be requested
  /// Returns true if permission should be requested
  Future<bool> shouldRequestPermission() async {
    final status = ref.read(permissionStatusProvider);
    return status == PermissionStatus.notRequested || status == PermissionStatus.denied;
  }
}

/// Provider for PermissionInitializationService
final permissionInitServiceProvider = Provider((ref) {
  return PermissionInitializationService(ref);
});

