import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/services/media/media_scanner.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// Local data source for media queries
/// Handles direct queries to the device's media library
class LocalMediaDataSource {
  final MediaScannerService _mediaScannerService;
  final AppLogger _logger = AppLogger();

  LocalMediaDataSource(this._mediaScannerService);

  /// Get all tracks from device
  Future<List<Track>> getAllTracks() async {
    _logger.info('LocalMediaDataSource: Fetching all tracks');
    return _mediaScannerService.getAllTracks();
  }

  /// Get all albums from device
  Future<List<Album>> getAllAlbums() async {
    _logger.info('LocalMediaDataSource: Fetching all albums');
    return _mediaScannerService.getAllAlbums();
  }

  /// Get all artists from device
  Future<List<Artist>> getAllArtists() async {
    _logger.info('LocalMediaDataSource: Fetching all artists');
    return _mediaScannerService.getAllArtists();
  }

  /// Get tracks for specific album
  Future<List<Track>> getTracksForAlbum(String albumId) async {
    _logger.info('LocalMediaDataSource: Fetching tracks for album: $albumId');
    return _mediaScannerService.getTracksForAlbum(albumId);
  }

  /// Get tracks for specific artist
  Future<List<Track>> getTracksForArtist(String artistId) async {
    _logger.info('LocalMediaDataSource: Fetching tracks for artist: $artistId');
    return _mediaScannerService.getTracksForArtist(artistId);
  }

  /// Search for tracks
  Future<List<Track>> searchTracks(String query) async {
    _logger.info('LocalMediaDataSource: Searching for tracks: $query');
    return _mediaScannerService.searchTracks(query);
  }

  /// Get artwork for track
  Future<List<int>?> getTrackArtwork(int trackId) async {
    _logger.info('LocalMediaDataSource: Fetching artwork for track: $trackId');
    return _mediaScannerService.getTrackArtwork(trackId);
  }

  /// Get artwork for album
  Future<List<int>?> getAlbumArtwork(int albumId) async {
    _logger.info('LocalMediaDataSource: Fetching artwork for album: $albumId');
    return _mediaScannerService.getAlbumArtwork(albumId);
  }

  /// Get total track count
  Future<int> getTrackCount() async {
    _logger.info('LocalMediaDataSource: Getting track count');
    return _mediaScannerService.getTrackCount();
  }
}

