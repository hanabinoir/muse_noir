import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';
import 'package:muse_noir/data/datasources/local_media_datasource.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// Implementation of MediaRepository using local media data source
class MediaRepositoryImpl implements MediaRepository {
  final LocalMediaDataSource _localMediaDataSource;
  final AppLogger _logger = AppLogger();

  MediaRepositoryImpl(this._localMediaDataSource);

  @override
  Future<List<Track>> getAllTracks() async {
    _logger.info('MediaRepositoryImpl: Getting all tracks');
    try {
      return await _localMediaDataSource.getAllTracks();
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting all tracks: $e');
      rethrow;
    }
  }

  @override
  Future<List<Album>> getAllAlbums() async {
    _logger.info('MediaRepositoryImpl: Getting all albums');
    try {
      return await _localMediaDataSource.getAllAlbums();
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting all albums: $e');
      rethrow;
    }
  }

  @override
  Future<List<Artist>> getAllArtists() async {
    _logger.info('MediaRepositoryImpl: Getting all artists');
    try {
      return await _localMediaDataSource.getAllArtists();
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting all artists: $e');
      rethrow;
    }
  }

  @override
  Future<List<Track>> getTracksForAlbum(String albumId) async {
    _logger.info('MediaRepositoryImpl: Getting tracks for album: $albumId');
    try {
      return await _localMediaDataSource.getTracksForAlbum(albumId);
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting tracks for album: $e');
      rethrow;
    }
  }

  @override
  Future<List<Track>> getTracksForArtist(String artistId) async {
    _logger.info('MediaRepositoryImpl: Getting tracks for artist: $artistId');
    try {
      return await _localMediaDataSource.getTracksForArtist(artistId);
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting tracks for artist: $e');
      rethrow;
    }
  }

  @override
  Future<List<Track>> searchTracks(String query) async {
    _logger.info('MediaRepositoryImpl: Searching tracks: $query');
    try {
      return await _localMediaDataSource.searchTracks(query);
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error searching tracks: $e');
      rethrow;
    }
  }

  @override
  Future<List<int>?> getTrackArtwork(int trackId) async {
    _logger.info('MediaRepositoryImpl: Getting artwork for track: $trackId');
    try {
      return await _localMediaDataSource.getTrackArtwork(trackId);
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting track artwork: $e');
      return null;
    }
  }

  @override
  Future<List<int>?> getAlbumArtwork(int albumId) async {
    _logger.info('MediaRepositoryImpl: Getting artwork for album: $albumId');
    try {
      return await _localMediaDataSource.getAlbumArtwork(albumId);
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting album artwork: $e');
      return null;
    }
  }

  @override
  Future<int> getTrackCount() async {
    _logger.info('MediaRepositoryImpl: Getting track count');
    try {
      return await _localMediaDataSource.getTrackCount();
    } catch (e) {
      _logger.error('MediaRepositoryImpl: Error getting track count: $e');
      return 0;
    }
  }
}

