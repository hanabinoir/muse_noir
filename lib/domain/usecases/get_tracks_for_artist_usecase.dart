import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for getting tracks for a specific artist
class GetTracksForArtistUsecase {
  final MediaRepository repository;

  GetTracksForArtistUsecase(this.repository);

  Future<List<Track>> call(String artistId) async {
    return await repository.getTracksForArtist(artistId);
  }
}

