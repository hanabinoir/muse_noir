import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for deleting a playlist
class DeletePlaylistUsecase {
  final PlaylistRepository repository;

  DeletePlaylistUsecase(this.repository);

  Future<void> call(String playlistId) async {
    return await repository.deletePlaylist(playlistId);
  }
}

