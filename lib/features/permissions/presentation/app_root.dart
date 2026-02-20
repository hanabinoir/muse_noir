import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/permissions/services/permission_initialization_service.dart';
import 'package:muse_noir/features/permissions/presentation/screens/permission_request_screen.dart';
import 'package:muse_noir/core/utils/logger.dart';

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
      _logger.info('AppRoot: Initializing permissions');

      final initService = ref.read(permissionInitServiceProvider);
      final isGranted = await initService.initializePermissions();

      if (mounted) {
        setState(() {
          _permissionsInitialized = true;
          _showMainApp = isGranted;
        });

        _logger.info('AppRoot: Permissions initialized, showMainApp: $isGranted');
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
                color: Colors.purple.withOpacity(0.2),
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

