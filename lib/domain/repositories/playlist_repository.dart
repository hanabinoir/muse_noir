import 'package:muse_noir/domain/entities/playlist.dart';

/// Repository interface for playlist operations
abstract class PlaylistRepository {
  /// Get all playlists
  Future<List<Playlist>> getAllPlaylists();

  /// Get a specific playlist by ID
  Future<Playlist?> getPlaylistById(String playlistId);

  /// Create a new playlist
  Future<Playlist> createPlaylist(String name, {String? description});

  /// Update an existing playlist
  Future<void> updatePlaylist(Playlist playlist);

  /// Delete a playlist
  Future<void> deletePlaylist(String playlistId);

  /// Add a track to a playlist
  Future<void> addTrackToPlaylist(String playlistId, int trackId);

  /// Remove a track from a playlist
  Future<void> removeTrackFromPlaylist(String playlistId, int trackId);

  /// Get all favorite track IDs
  Future<List<int>> getFavorites();

  /// Add a track to favorites
  Future<void> addToFavorites(int trackId);

  /// Remove a track from favorites
  Future<void> removeFromFavorites(int trackId);

  /// Check if a track is in favorites
  Future<bool> isFavorite(int trackId);

  /// Clear all playlists
  Future<void> clearAll();
}

