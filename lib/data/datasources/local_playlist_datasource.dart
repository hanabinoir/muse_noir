import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/services/storage/hive_service.dart';

/// Local data source for playlist operations using Hive
class LocalPlaylistDataSource {
  final AppLogger _logger = AppLogger();
  final HiveService _hiveService = HiveService();

  /// Ensure Hive is initialized before performing operations
  void _ensureInitialized() {
    if (!_hiveService.isInitialized) {
      throw StateError('HiveService has not been initialized. Call initialize() on AppRoot.');
    }
  }

  /// Get all playlists
  Future<List<Playlist>> getAllPlaylists() async {
    try {
      _ensureInitialized();
      final playlists = _hiveService.playlistBox.values.toList();
      _logger.info('Retrieved ${playlists.length} playlists');
      return playlists;
    } catch (e, st) {
      _logger.error('Error getting all playlists', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Get a specific playlist by ID
  Future<Playlist?> getPlaylistById(String playlistId) async {
    try {
      _ensureInitialized();
      final playlist = _hiveService.playlistBox.get(playlistId);
      _logger.info('Retrieved playlist: $playlistId');
      return playlist;
    } catch (e, st) {
      _logger.error('Error getting playlist by ID', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Create a new playlist
  Future<Playlist> createPlaylist(String name, {String? description}) async {
    try {
      _ensureInitialized();
      final playlist = Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        trackIds: [],
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        description: description,
      );
      await _hiveService.playlistBox.put(playlist.id, playlist);
      _logger.info('Created playlist: ${playlist.id}');
      return playlist;
    } catch (e, st) {
      _logger.error('Error creating playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Update an existing playlist
  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      _ensureInitialized();
      await _hiveService.playlistBox.put(playlist.id, playlist);
      _logger.info('Updated playlist: ${playlist.id}');
    } catch (e, st) {
      _logger.error('Error updating playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Delete a playlist
  Future<void> deletePlaylist(String playlistId) async {
    try {
      _ensureInitialized();
      await _hiveService.playlistBox.delete(playlistId);
      _logger.info('Deleted playlist: $playlistId');
    } catch (e, st) {
      _logger.error('Error deleting playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Add a track to a playlist
  Future<void> addTrackToPlaylist(String playlistId, int trackId) async {
    try {
      _ensureInitialized();
      final playlist = _hiveService.playlistBox.get(playlistId);
      if (playlist != null) {
        final updatedPlaylist = playlist.addTrack(trackId);
        await _hiveService.playlistBox.put(playlistId, updatedPlaylist);
        _logger.info('Added track $trackId to playlist $playlistId');
      }
    } catch (e, st) {
      _logger.error('Error adding track to playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Remove a track from a playlist
  Future<void> removeTrackFromPlaylist(String playlistId, int trackId) async {
    try {
      _ensureInitialized();
      final playlist = _hiveService.playlistBox.get(playlistId);
      if (playlist != null) {
        final updatedPlaylist = playlist.removeTrack(trackId);
        await _hiveService.playlistBox.put(playlistId, updatedPlaylist);
        _logger.info('Removed track $trackId from playlist $playlistId');
      }
    } catch (e, st) {
      _logger.error('Error removing track from playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Get all favorite track IDs
  Future<List<int>> getFavorites() async {
    try {
      _ensureInitialized();
      final favorites = _hiveService.favoritesBox.get('favorites') ?? [];
      _logger.info('Retrieved ${favorites.length} favorites');
      return favorites;
    } catch (e, st) {
      _logger.error('Error getting favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Add a track to favorites
  Future<void> addToFavorites(int trackId) async {
    try {
      _ensureInitialized();
      final favorites = _hiveService.favoritesBox.get('favorites') ?? [];
      if (!favorites.contains(trackId)) {
        favorites.add(trackId);
        await _hiveService.favoritesBox.put('favorites', favorites);
        _logger.info('Added track $trackId to favorites');
      }
    } catch (e, st) {
      _logger.error('Error adding to favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Remove a track from favorites
  Future<void> removeFromFavorites(int trackId) async {
    try {
      _ensureInitialized();
      final favorites = _hiveService.favoritesBox.get('favorites') ?? [];
      favorites.remove(trackId);
      await _hiveService.favoritesBox.put('favorites', favorites);
      _logger.info('Removed track $trackId from favorites');
    } catch (e, st) {
      _logger.error('Error removing from favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Check if a track is in favorites
  Future<bool> isFavorite(int trackId) async {
    try {
      _ensureInitialized();
      final favorites = _hiveService.favoritesBox.get('favorites') ?? [];
      return favorites.contains(trackId);
    } catch (e, st) {
      _logger.error('Error checking favorite status', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Clear all playlists and favorites
  Future<void> clearAll() async {
    try {
      _ensureInitialized();
      await _hiveService.playlistBox.clear();
      await _hiveService.favoritesBox.clear();
      _logger.info('Cleared all playlists and favorites');
    } catch (e, st) {
      _logger.error('Error clearing all', error: e, stackTrace: st);
      rethrow;
    }
  }
}
