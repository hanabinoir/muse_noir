import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/domain/repositories/playlist_repository.dart';

/// Use case for creating a playlist
class CreatePlaylistUsecase {
  final PlaylistRepository repository;

  CreatePlaylistUsecase(this.repository);

  Future<Playlist> call(String name, {String? description}) async {
    return await repository.createPlaylist(name, description: description);
  }
}

