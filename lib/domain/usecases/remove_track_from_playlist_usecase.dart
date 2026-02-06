import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for removing a track from a playlist
class RemoveTrackFromPlaylistUsecase {
  final PlaylistRepository repository;

  RemoveTrackFromPlaylistUsecase(this.repository);

  Future<void> call(String playlistId, int trackId) async {
    return await repository.removeTrackFromPlaylist(playlistId, trackId);
  }
}

