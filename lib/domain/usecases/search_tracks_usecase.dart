import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for searching tracks
class SearchTracksUsecase {
  final MediaRepository repository;

  SearchTracksUsecase(this.repository);

  Future<List<Track>> call(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await repository.searchTracks(query);
  }
}

