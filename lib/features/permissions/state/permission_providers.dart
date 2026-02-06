import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_state.dart';

/// Provider for permission status
final permissionStatusProvider =
    NotifierProvider<PermissionNotifier, PermissionStatus>(() {
  return PermissionNotifier();
});

