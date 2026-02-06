import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for getting all tracks
class GetAllTracksUsecase {
  final MediaRepository repository;

  GetAllTracksUsecase(this.repository);

  Future<List<Track>> call() async {
    return await repository.getAllTracks();
  }
}

