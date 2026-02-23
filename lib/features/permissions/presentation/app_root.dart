import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/services/permission_initialization_service.dart';
import 'package:muse_noir/features/permissions/presentation/screens/permission_request_screen.dart';
import 'package:muse_noir/features/permissions/state/permission_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/services/storage/hive_service.dart';

/// Root widget that handles permission checks and app initialization
/// Shows permission request screen if needed, otherwise shows main app content
class AppRoot extends ConsumerStatefulWidget {
  final Widget mainAppWidget;

  const AppRoot({
    super.key,
    required this.mainAppWidget,
  });

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  late AppLogger _logger;
  bool _permissionsInitialized = false;
  bool _showMainApp = false;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    try {
      _logger.info('AppRoot: Initializing permissions and Hive');

      // Initialize Hive service first
      final hiveService = HiveService();
      await hiveService.initialize();
      _logger.info('AppRoot: HiveService initialized successfully');

      final initService = ref.read(permissionInitServiceProvider);

      // Initialize media permission (critical)
      final mediaGranted = await initService.initializePermissions();
      _logger.info('AppRoot: Media permission status: $mediaGranted');

      // Initialize notification permission (for lock screen display)
      final notificationGranted = await initService.initializeNotificationPermission();
      _logger.info('AppRoot: Notification permission status: $notificationGranted');

      // If media permission not granted, request it through UI
      if (!mediaGranted) {
        _logger.info('AppRoot: Media permission not granted, showing permission screen');
        if (mounted) {
          setState(() {
            _permissionsInitialized = true;
            _showMainApp = false;
          });
        }
        return;
      }

      // Media permission granted, try to auto-request notification permission if not granted
      if (!notificationGranted) {
        _logger.info('AppRoot: Attempting to auto-request notification permission');
        final notificationNotifier = ref.read(notificationPermissionStatusProvider.notifier);
        await notificationNotifier.requestPermission();
      }

      if (mounted) {
        setState(() {
          _permissionsInitialized = true;
          _showMainApp = true;
        });

        _logger.info('AppRoot: All permissions initialized, showing main app');
      }
    } catch (e, stackTrace) {
      _logger.error(
        'AppRoot: Error initializing permissions',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _permissionsInitialized = true;
          _showMainApp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionsInitialized) {
      return _buildLoadingScreen();
    }

    if (_showMainApp) {
      return widget.mainAppWidget;
    }

    return PermissionRequestScreen(
      onPermissionGranted: () {
        _logger.info('AppRoot: Permission granted from screen');
        setState(() {
          _showMainApp = true;
        });
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note,
                size: 50,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Muse Noir',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Initializing...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

