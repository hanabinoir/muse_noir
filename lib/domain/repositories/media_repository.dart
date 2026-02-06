import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/domain/entities/track.dart';

/// Repository interface for media operations
abstract class MediaRepository {
  /// Get all tracks from the device
  Future<List<Track>> getAllTracks();

  /// Get all albums from the device
  Future<List<Album>> getAllAlbums();

  /// Get all artists from the device
  Future<List<Artist>> getAllArtists();

  /// Get tracks for a specific album
  Future<List<Track>> getTracksForAlbum(String albumId);

  /// Get tracks for a specific artist
  Future<List<Track>> getTracksForArtist(String artistId);

  /// Search tracks by query
  Future<List<Track>> searchTracks(String query);

  /// Get artwork for a track
  Future<List<int>?> getTrackArtwork(int trackId);

  /// Get artwork for an album
  Future<List<int>?> getAlbumArtwork(int albumId);

  /// Get total count of tracks on device
  Future<int> getTrackCount();
}

