import 'package:muse_noir/services/permissions/permission_service.dart';
import 'package:muse_noir/services/media/media_scanner.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/core/errors/app_exception.dart';

/// Service for initializing and managing media library
class MediaLibraryService {
  final PermissionService _permissionService;
  final MediaScannerService _mediaScannerService;
  final AppLogger _logger = AppLogger();

  bool _isInitialized = false;

  MediaLibraryService(this._permissionService, this._mediaScannerService);

  /// Check if library has been initialized
  bool get isInitialized => _isInitialized;

  /// Initialize media library
  /// Checks permissions and scans for media files
  Future<bool> initialize() async {
    try {
      _logger.info('Initializing media library...');

      // Check if we already have permission
      bool hasPermission = await _permissionService.hasMediaPermission();

      if (!hasPermission) {
        _logger.warning('No media permission, requesting...');
        hasPermission = await _permissionService.requestMediaPermission();
      }

      if (!hasPermission) {
        _logger.error('Failed to obtain media permission');
        _isInitialized = false;
        return false;
      }

      // Permission granted, scan for media
      _logger.info('Permission granted, scanning media library...');
      final trackCount = await _mediaScannerService.getTrackCount();
      _logger.info('Media library scan complete. Found $trackCount tracks');

      _isInitialized = true;
      return true;
    } catch (e) {
      _logger.error('Error initializing media library: $e');
      _isInitialized = false;
      throw MediaScanException(message: 'Failed to initialize media library: $e');
    }
  }

  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    return await _permissionService.isMediaPermissionPermanentlyDenied();
  }

  /// Request permission
  Future<bool> requestPermission() async {
    return await _permissionService.requestMediaPermission();
  }

  /// Get total track count in library
  Future<int> getLibrarySize() async {
    if (!_isInitialized) {
      throw MediaScanException(message: 'Media library not initialized');
    }
    return await _mediaScannerService.getTrackCount();
  }
}

