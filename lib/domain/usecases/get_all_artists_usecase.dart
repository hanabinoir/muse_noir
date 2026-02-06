import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for getting all artists
class GetAllArtistsUsecase {
  final MediaRepository repository;

  GetAllArtistsUsecase(this.repository);

  Future<List<Artist>> call() async {
    return await repository.getAllArtists();
  }
}

