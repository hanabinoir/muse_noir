import 'package:hive/hive.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/data/datasources/hive_adapters/playlist_adapter.dart';

/// Service for managing Hive database initialization and operations
class HiveService {
  static final HiveService _instance = HiveService._internal();
  final AppLogger _logger = AppLogger();

  bool _initialized = false;

  late Box<Playlist> _playlistBox;
  late Box<List<int>> _favoritesBox;

  static const String _playlistBoxName = 'playlists';
  static const String _favoritesBoxName = 'favorites';

  HiveService._internal();

  /// Get singleton instance
  factory HiveService() {
    return _instance;
  }

  /// Check if Hive has been initialized
  bool get isInitialized => _initialized;

  /// Get the playlist box
  Box<Playlist> get playlistBox {
    if (!_initialized) {
      throw StateError('HiveService has not been initialized. Call initialize() first.');
    }
    return _playlistBox;
  }

  /// Get the favorites box
  Box<List<int>> get favoritesBox {
    if (!_initialized) {
      throw StateError('HiveService has not been initialized. Call initialize() first.');
    }
    return _favoritesBox;
  }

  /// Initialize Hive with all boxes and adapters
  /// This should be called once during app startup after Hive.initFlutter()
  Future<void> initialize() async {
    if (_initialized) {
      _logger.info('HiveService already initialized');
      return;
    }

    try {
      _logger.info('Initializing HiveService...');

      // Register adapters if not already registered
      if (!Hive.isAdapterRegistered(PlaylistAdapter().typeId)) {
        Hive.registerAdapter(PlaylistAdapter());
        _logger.info('Registered PlaylistAdapter');
      }

      // Open boxes
      _playlistBox = await Hive.openBox<Playlist>(_playlistBoxName);
      _logger.info('Opened playlist box');

      _favoritesBox = await Hive.openBox<List<int>>(_favoritesBoxName);
      _logger.info('Opened favorites box');

      _initialized = true;
      _logger.info('HiveService initialized successfully');
    } catch (e, st) {
      _logger.error('Error initializing HiveService', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Close all boxes
  Future<void> close() async {
    try {
      _logger.info('Closing HiveService');
      if (_playlistBox.isOpen) {
        await _playlistBox.close();
      }
      if (_favoritesBox.isOpen) {
        await _favoritesBox.close();
      }
      _initialized = false;
      _logger.info('HiveService closed successfully');
    } catch (e, st) {
      _logger.error('Error closing HiveService', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Clear all data from all boxes
  Future<void> clearAll() async {
    try {
      _logger.info('Clearing all Hive boxes');
      if (_playlistBox.isOpen) {
        await _playlistBox.clear();
      }
      if (_favoritesBox.isOpen) {
        await _favoritesBox.clear();
      }
      _logger.info('All Hive boxes cleared');
    } catch (e, st) {
      _logger.error('Error clearing Hive boxes', error: e, stackTrace: st);
      rethrow;
    }
  }
}

