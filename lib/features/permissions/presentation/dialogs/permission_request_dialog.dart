import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

import '../../state/permission_state.dart';

/// Dialog shown to request permissions from within the app
class PermissionRequestDialog extends ConsumerWidget {
  final VoidCallback onPermissionGranted;
  final String? title;
  final String? description;

  const PermissionRequestDialog({
    super.key,
    required this.onPermissionGranted,
    this.title,
    this.description,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onPermissionGranted,
    String? title,
    String? description,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionRequestDialog(
        onPermissionGranted: onPermissionGranted,
        title: title,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionStatus = ref.watch(permissionStatusProvider);
    final logger = AppLogger();

    return AlertDialog(
      title: Text(title ?? 'Permission Required'),
      content: Text(
        description ??
            'Muse Noir needs permission to access your music files. '
            'This allows us to discover and play your local music library.',
      ),
      actions: [
        if (permissionStatus != PermissionStatus.permanentlyDenied)
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: () async {
            logger.info('Dialog: User tapped request/settings button');
            final notifier = ref.read(permissionStatusProvider.notifier);

            if (permissionStatus == PermissionStatus.permanentlyDenied) {
              await notifier.openSettings();
              if (context.mounted) {
                Navigator.pop(context, false);
              }
            } else {
              final granted = await notifier.requestPermission();
              if (context.mounted) {
                Navigator.pop(context, granted);
                if (granted) {
                  onPermissionGranted();
                }
              }
            }
          },
          child: Text(
            permissionStatus == PermissionStatus.permanentlyDenied
                ? 'Open Settings'
                : 'Grant Permission',
          ),
        ),
      ],
    );
  }
}

