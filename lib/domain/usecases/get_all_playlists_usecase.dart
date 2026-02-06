import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for getting all playlists
class GetAllPlaylistsUsecase {
  final PlaylistRepository repository;

  GetAllPlaylistsUsecase(this.repository);

  Future<List<Playlist>> call() async {
    return await repository.getAllPlaylists();
  }
}

