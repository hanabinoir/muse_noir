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

  /// Get tracks by album ID
  Future<List<Track>> getTracksByAlbum(int albumId);

  /// Get tracks by artist ID
  Future<List<Track>> getTracksByArtist(int artistId);

  /// Search tracks by query
  Future<List<Track>> searchTracks(String query);

  /// Get a specific track by ID
  Future<Track?> getTrackById(int trackId);

  /// Get a specific album by ID
  Future<Album?> getAlbumById(int albumId);

  /// Get a specific artist by ID
  Future<Artist?> getArtistById(int artistId);

  /// Refresh the media library (scan for new files)
  Future<void> refreshLibrary();

  /// Check if library has been scanned
  Future<bool> isLibraryScanned();

  /// Clear cached media data
  Future<void> clearCache();
}

