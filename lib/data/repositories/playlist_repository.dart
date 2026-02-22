import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/data/datasources/local_playlist_datasource.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Implementation of PlaylistRepository
class PlaylistRepositoryImpl implements PlaylistRepository {
  final LocalPlaylistDataSource _localDataSource;
  final AppLogger _logger = AppLogger();

  PlaylistRepositoryImpl(this._localDataSource);

  @override
  Future<List<Playlist>> getAllPlaylists() async {
    try {
      _logger.info('Fetching all playlists from repository');
      final playlists = await _localDataSource.getAllPlaylists();
      return playlists;
    } catch (e, st) {
      _logger.error('Error fetching all playlists', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Playlist?> getPlaylistById(String playlistId) async {
    try {
      _logger.info('Fetching playlist: $playlistId');
      return await _localDataSource.getPlaylistById(playlistId);
    } catch (e, st) {
      _logger.error('Error fetching playlist by ID', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Playlist> createPlaylist(String name, {String? description}) async {
    try {
      _logger.info('Creating playlist: $name');
      return await _localDataSource.createPlaylist(name, description: description);
    } catch (e, st) {
      _logger.error('Error creating playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      _logger.info('Updating playlist: ${playlist.id}');
      await _localDataSource.updatePlaylist(playlist);
    } catch (e, st) {
      _logger.error('Error updating playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    try {
      _logger.info('Deleting playlist: $playlistId');
      await _localDataSource.deletePlaylist(playlistId);
    } catch (e, st) {
      _logger.error('Error deleting playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> addTrackToPlaylist(String playlistId, int trackId) async {
    try {
      _logger.info('Adding track $trackId to playlist $playlistId');
      await _localDataSource.addTrackToPlaylist(playlistId, trackId);
    } catch (e, st) {
      _logger.error('Error adding track to playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> removeTrackFromPlaylist(String playlistId, int trackId) async {
    try {
      _logger.info('Removing track $trackId from playlist $playlistId');
      await _localDataSource.removeTrackFromPlaylist(playlistId, trackId);
    } catch (e, st) {
      _logger.error('Error removing track from playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<int>> getFavorites() async {
    try {
      _logger.info('Fetching favorites');
      return await _localDataSource.getFavorites();
    } catch (e, st) {
      _logger.error('Error fetching favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> addToFavorites(int trackId) async {
    try {
      _logger.info('Adding track $trackId to favorites');
      await _localDataSource.addToFavorites(trackId);
    } catch (e, st) {
      _logger.error('Error adding to favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(int trackId) async {
    try {
      _logger.info('Removing track $trackId from favorites');
      await _localDataSource.removeFromFavorites(trackId);
    } catch (e, st) {
      _logger.error('Error removing from favorites', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(int trackId) async {
    try {
      return await _localDataSource.isFavorite(trackId);
    } catch (e, st) {
      _logger.error('Error checking favorite status', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      _logger.info('Clearing all playlists and favorites');
      await _localDataSource.clearAll();
    } catch (e, st) {
      _logger.error('Error clearing all', error: e, stackTrace: st);
      rethrow;
    }
  }
}

