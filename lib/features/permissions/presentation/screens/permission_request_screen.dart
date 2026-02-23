import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

import '../../state/permission_state.dart';

/// Screen shown when the app needs to request media permissions
/// Guides users to grant READ_MEDIA_AUDIO and POST_NOTIFICATIONS permissions
class PermissionRequestScreen extends ConsumerWidget {
  final VoidCallback onPermissionGranted;
  static const routeName = '/permission-request';

  const PermissionRequestScreen({
    super.key,
    required this.onPermissionGranted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPermissionStatus = ref.watch(permissionStatusProvider);
    final notificationPermissionStatus = ref.watch(notificationPermissionStatusProvider);
    final logger = AppLogger();

    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 60,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Permissions Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Muse Noir needs permissions to access your music files and show notifications. '
                  'We need access to your device\'s audio files to play them and notifications for lock screen controls.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Permission details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What we need:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _buildPermissionItem(
                        context,
                        Icons.audio_file,
                        'Audio Files Access (Required)',
                        'Read permission to access your music library',
                        mediaPermissionStatus == PermissionStatus.granted,
                      ),
                      const SizedBox(height: 12),
                      _buildPermissionItem(
                        context,
                        Icons.notifications,
                        'Notifications (Android 13+)',
                        'Display lock screen controls for music playback',
                        notificationPermissionStatus == PermissionStatus.granted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Request Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      logger.info('User tapped request permission');

                      // Request media permission (critical)
                      final mediaNotifier = ref.read(permissionStatusProvider.notifier);
                      final mediaGranted = await mediaNotifier.requestPermission();

                      // Request notification permission (for lock screen)
                      final notificationNotifier = ref.read(notificationPermissionStatusProvider.notifier);
                      await notificationNotifier.requestPermission();

                      if (mediaGranted) {
                        logger.info('Media permission granted, calling callback');
                        onPermissionGranted();
                      }
                    },
                    child: const Text(
                      'Grant Permissions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Help link
                if (mediaPermissionStatus == PermissionStatus.permanentlyDenied)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        logger.info('User tapped open settings');
                        final notifier = ref.read(permissionStatusProvider.notifier);
                        await notifier.openSettings();
                      },
                      child: const Text(
                        'Open App Settings',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    bool isGranted,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isGranted ? Icons.check_circle : icon,
          color: isGranted ? Colors.green : Colors.purple,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isGranted ? Colors.green : Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

