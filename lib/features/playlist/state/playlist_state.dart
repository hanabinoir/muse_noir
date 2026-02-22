import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/core/providers/providers.dart';
import 'package:muse_noir/domain/entities/playlist.dart';

/// Playlist state for managing playlist operations
class PlaylistUIState {
  final bool isLoading;
  final String? error;

  const PlaylistUIState({
    this.isLoading = false,
    this.error,
  });

  PlaylistUIState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return PlaylistUIState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Playlist UI state notifier
class PlaylistUIStateNotifier extends Notifier<PlaylistUIState> {
  final AppLogger _logger = AppLogger();

  @override
  PlaylistUIState build() {
    return const PlaylistUIState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// State notifier for managing all playlists
class PlaylistsNotifier extends Notifier<List<Playlist>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Playlist> build() {
    return [];
  }

  /// Fetch all playlists from repository
  Future<void> fetchAllPlaylists() async {
    try {
      _logger.info('Fetching all playlists');
      final getAllPlaylistsUsecase = ref.watch(getAllPlaylistsUsecaseProvider);
      state = await getAllPlaylistsUsecase.call();
      _logger.info('Fetched ${state.length} playlists');
    } catch (e, stackTrace) {
      _logger.error('Error fetching playlists: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Create a new playlist
  Future<Playlist> createPlaylist(String name, {String? description}) async {
    try {
      _logger.info('Creating playlist: $name');
      final createPlaylistUsecase = ref.watch(createPlaylistUsecaseProvider);
      final playlist = await createPlaylistUsecase.call(name, description: description);
      state = [...state, playlist];
      _logger.info('Created playlist: ${playlist.id}');
      return playlist;
    } catch (e, stackTrace) {
      _logger.error('Error creating playlist: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Update a playlist
  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      _logger.info('Updating playlist: ${playlist.id}');
      final updatePlaylistUsecase = ref.watch(updatePlaylistUsecaseProvider);
      await updatePlaylistUsecase.call(playlist);
      state = [
        for (final p in state)
          if (p.id == playlist.id) playlist else p
      ];
      _logger.info('Updated playlist: ${playlist.id}');
    } catch (e, stackTrace) {
      _logger.error('Error updating playlist: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Delete a playlist
  Future<void> deletePlaylist(String playlistId) async {
    try {
      _logger.info('Deleting playlist: $playlistId');
      final deletePlaylistUsecase = ref.watch(deletePlaylistUsecaseProvider);
      await deletePlaylistUsecase.call(playlistId);
      state = state.where((p) => p.id != playlistId).toList();
      _logger.info('Deleted playlist: $playlistId');
    } catch (e, stackTrace) {
      _logger.error('Error deleting playlist: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Add a track to a playlist
  Future<void> addTrackToPlaylist(String playlistId, int trackId) async {
    try {
      _logger.info('Adding track $trackId to playlist $playlistId');
      final addTrackUsecase = ref.watch(addTrackToPlaylistUsecaseProvider);
      await addTrackUsecase.call(playlistId, trackId);

      // Update the local state
      final playlistIndex = state.indexWhere((p) => p.id == playlistId);
      if (playlistIndex != -1) {
        final updatedPlaylist = state[playlistIndex].addTrack(trackId);
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == playlistIndex) updatedPlaylist else state[i]
        ];
      }
      _logger.info('Added track $trackId to playlist $playlistId');
    } catch (e, stackTrace) {
      _logger.error('Error adding track to playlist: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove a track from a playlist
  Future<void> removeTrackFromPlaylist(String playlistId, int trackId) async {
    try {
      _logger.info('Removing track $trackId from playlist $playlistId');
      final removeTrackUsecase = ref.watch(removeTrackFromPlaylistUsecaseProvider);
      await removeTrackUsecase.call(playlistId, trackId);

      // Update the local state
      final playlistIndex = state.indexWhere((p) => p.id == playlistId);
      if (playlistIndex != -1) {
        final updatedPlaylist = state[playlistIndex].removeTrack(trackId);
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == playlistIndex) updatedPlaylist else state[i]
        ];
      }
      _logger.info('Removed track $trackId from playlist $playlistId');
    } catch (e, stackTrace) {
      _logger.error('Error removing track from playlist: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing favorites
class FavoritesNotifier extends Notifier<List<int>> {
  final AppLogger _logger = AppLogger();

  @override
  List<int> build() {
    return [];
  }

  /// Fetch all favorites
  Future<void> fetchFavorites() async {
    try {
      _logger.info('Fetching favorites');
      final getFavoritesUsecase = ref.watch(getFavoritesUsecaseProvider);
      state = await getFavoritesUsecase.call();
      _logger.info('Fetched ${state.length} favorites');
    } catch (e, stackTrace) {
      _logger.error('Error fetching favorites: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Add a track to favorites
  Future<void> addToFavorites(int trackId) async {
    try {
      _logger.info('Adding track $trackId to favorites');
      final addToFavoritesUsecase = ref.watch(addToFavoritesUsecaseProvider);
      await addToFavoritesUsecase.call(trackId);
      if (!state.contains(trackId)) {
        state = [...state, trackId];
      }
      _logger.info('Added track $trackId to favorites');
    } catch (e, stackTrace) {
      _logger.error('Error adding to favorites: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove a track from favorites
  Future<void> removeFromFavorites(int trackId) async {
    try {
      _logger.info('Removing track $trackId from favorites');
      final removeFromFavoritesUsecase = ref.watch(removeFromFavoritesUsecaseProvider);
      await removeFromFavoritesUsecase.call(trackId);
      state = state.where((id) => id != trackId).toList();
      _logger.info('Removed track $trackId from favorites');
    } catch (e, stackTrace) {
      _logger.error('Error removing from favorites: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Check if a track is in favorites
  Future<bool> isFavorite(int trackId) async {
    try {
      return state.contains(trackId);
    } catch (e, stackTrace) {
      _logger.error('Error checking favorite status: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// Playlist UI state provider
final playlistUIStateProvider =
    NotifierProvider<PlaylistUIStateNotifier, PlaylistUIState>(() {
  return PlaylistUIStateNotifier();
});

/// All playlists provider
final playlistsProvider = NotifierProvider<PlaylistsNotifier, List<Playlist>>(() {
  return PlaylistsNotifier();
});

/// Favorites provider
final favoritesProvider = NotifierProvider<FavoritesNotifier, List<int>>(() {
  return FavoritesNotifier();
});



