import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_state.dart';

/// Provider for media permission status
final permissionStatusProvider =
    NotifierProvider<PermissionNotifier, PermissionStatus>(() {
  return PermissionNotifier();
});

/// Provider for notification permission status (Android 13+)
final notificationPermissionStatusProvider =
    NotifierProvider<NotificationPermissionNotifier, PermissionStatus>(() {
  return NotificationPermissionNotifier();
});

