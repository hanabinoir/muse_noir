import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';

/// Use case for getting all albums
class GetAllAlbumsUsecase {
  final MediaRepository repository;

  GetAllAlbumsUsecase(this.repository);

  Future<List<Album>> call() async {
    return await repository.getAllAlbums();
  }
}

