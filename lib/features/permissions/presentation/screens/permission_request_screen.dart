import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

import '../../state/permission_state.dart';

/// Screen shown when the app needs to request media permissions
/// Guides users to grant READ_MEDIA_AUDIO permission
class PermissionRequestScreen extends ConsumerWidget {
  final VoidCallback onPermissionGranted;
  static const routeName = '/permission-request';

  const PermissionRequestScreen({
    super.key,
    required this.onPermissionGranted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionStatus = ref.watch(permissionStatusProvider);
    final logger = AppLogger();

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
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
                    color: Colors.purple.withOpacity(0.2),
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
                  'Music Permission Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Muse Noir needs permission to access your music files. '
                  'We need access to your device\'s audio files to play them.',
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
                        'Audio Files Access',
                        'Read permission to access your music library',
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
                      final notifier = ref.read(permissionStatusProvider.notifier);
                      final granted = await notifier.requestPermission();
                      if (granted) {
                        logger.info('Permission granted, calling callback');
                        onPermissionGranted();
                      }
                    },
                    child: const Text(
                      'Grant Permission',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Help link
                if (permissionStatus == PermissionStatus.permanentlyDenied)
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
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.purple,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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

