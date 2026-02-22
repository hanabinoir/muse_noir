import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for getting all playlists
class GetAllPlaylistsUsecase {
  final PlaylistRepository repository;

  GetAllPlaylistsUsecase(this.repository);

  Future<List<Playlist>> call() {
    return repository.getAllPlaylists();
  }
}

/// Use case for getting a specific playlist
class GetPlaylistByIdUsecase {
  final PlaylistRepository repository;

  GetPlaylistByIdUsecase(this.repository);

  Future<Playlist?> call(String playlistId) {
    return repository.getPlaylistById(playlistId);
  }
}

/// Use case for creating a playlist
class CreatePlaylistUsecase {
  final PlaylistRepository repository;

  CreatePlaylistUsecase(this.repository);

  Future<Playlist> call(String name, {String? description}) {
    return repository.createPlaylist(name, description: description);
  }
}

/// Use case for updating a playlist
class UpdatePlaylistUsecase {
  final PlaylistRepository repository;

  UpdatePlaylistUsecase(this.repository);

  Future<void> call(Playlist playlist) {
    return repository.updatePlaylist(playlist);
  }
}

/// Use case for deleting a playlist
class DeletePlaylistUsecase {
  final PlaylistRepository repository;

  DeletePlaylistUsecase(this.repository);

  Future<void> call(String playlistId) {
    return repository.deletePlaylist(playlistId);
  }
}

/// Use case for adding a track to a playlist
class AddTrackToPlaylistUsecase {
  final PlaylistRepository repository;

  AddTrackToPlaylistUsecase(this.repository);

  Future<void> call(String playlistId, int trackId) {
    return repository.addTrackToPlaylist(playlistId, trackId);
  }
}

/// Use case for removing a track from a playlist
class RemoveTrackFromPlaylistUsecase {
  final PlaylistRepository repository;

  RemoveTrackFromPlaylistUsecase(this.repository);

  Future<void> call(String playlistId, int trackId) {
    return repository.removeTrackFromPlaylist(playlistId, trackId);
  }
}

/// Use case for getting favorites
class GetFavoritesUsecase {
  final PlaylistRepository repository;

  GetFavoritesUsecase(this.repository);

  Future<List<int>> call() {
    return repository.getFavorites();
  }
}

/// Use case for adding a track to favorites
class AddToFavoritesUsecase {
  final PlaylistRepository repository;

  AddToFavoritesUsecase(this.repository);

  Future<void> call(int trackId) {
    return repository.addToFavorites(trackId);
  }
}

/// Use case for removing a track from favorites
class RemoveFromFavoritesUsecase {
  final PlaylistRepository repository;

  RemoveFromFavoritesUsecase(this.repository);

  Future<void> call(int trackId) {
    return repository.removeFromFavorites(trackId);
  }
}

/// Use case for checking if a track is in favorites
class IsFavoriteUsecase {
  final PlaylistRepository repository;

  IsFavoriteUsecase(this.repository);

  Future<bool> call(int trackId) {
    return repository.isFavorite(trackId);
  }
}

