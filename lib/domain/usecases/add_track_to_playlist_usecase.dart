import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for adding a track to a playlist
class AddTrackToPlaylistUsecase {
  final PlaylistRepository repository;

  AddTrackToPlaylistUsecase(this.repository);

  Future<void> call(String playlistId, int trackId) async {
    return await repository.addTrackToPlaylist(playlistId, trackId);
  }
}

