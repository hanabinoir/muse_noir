import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for getting tracks for a specific album
class GetTracksForAlbumUsecase {
  final MediaRepository repository;

  GetTracksForAlbumUsecase(this.repository);

  Future<List<Track>> call(String albumId) async {
    return await repository.getTracksForAlbum(albumId);
  }
}

