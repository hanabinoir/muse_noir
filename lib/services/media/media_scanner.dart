import 'package:on_audio_query/on_audio_query.dart';
import 'package:muse_noir/core/errors/app_exception.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';

/// Service for scanning and querying media files from device storage
class MediaScannerService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AppLogger _logger = AppLogger();

  /// Get all audio tracks from the device
  /// Returns a list of Track entities sorted by title
  /// Only returns tracks from External Storage > Music directory
  Future<List<Track>> getAllTracks() async {
    try {
      _logger.info('Scanning for all tracks from External Storage Music directory...');

      // Query all audio files from external storage
      final tracks = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      // Filter tracks to only include those in the Music directory on external storage
      final musicTracks = tracks.where((song) {
        final path = song.data.toLowerCase();
        // Check if track is in Music folder on external storage (common paths)
        return path.contains('/music/');
      }).toList();

      _logger.info('Found ${musicTracks.length} tracks in External Storage Music directory');

      // Convert to Track entities
      final trackList = <Track>[];
      for (final song in musicTracks) {
        final artwork = await getTrackArtwork(song.id);
        trackList.add(Track(
          id: song.id,
          title: song.title,
          artist: song.artist ?? 'Unknown Artist',
          album: song.album ?? 'Unknown Album',
          duration: Duration(milliseconds: song.duration ?? 0),
          filePath: song.data,
          albumId: song.albumId?.toString(),
          artistId: song.artistId?.toString(),
          artwork: artwork,
        ));
      }

      return trackList;
    } catch (e) {
      _logger.error('Error scanning tracks: $e');
      throw MediaScanException(message: 'Failed to scan tracks: $e');
    }
  }

  /// Get all albums from the device
  /// Returns a list of Album entities sorted by name
  /// Scans External Storage Music directory
  Future<List<Album>> getAllAlbums() async {
    try {
      _logger.info('Scanning for all albums from External Storage...');

      final albums = await _audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _logger.info('Found ${albums.length} albums');

      // Convert to Album entities
      final albumList = <Album>[];
      for (final album in albums) {
        final artwork = await getAlbumArtwork(album.id);
        albumList.add(Album(
          id: album.id,
          title: album.album,
          artist: album.artist ?? 'Unknown Artist',
          numOfSongs: album.numOfSongs,
          trackIds: [],
          artwork: artwork,
        ));
      }

      return albumList;
    } catch (e) {
      _logger.error('Error scanning albums: $e');
      throw MediaScanException(message: 'Failed to scan albums: $e');
    }
  }

  /// Get all artists from the device
  /// Returns a list of Artist entities sorted by name
  /// Scans External Storage Music directory
  Future<List<Artist>> getAllArtists() async {
    try {
      _logger.info('Scanning for all artists from External Storage...');

      final artists = await _audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _logger.info('Found ${artists.length} artists');

      // Convert to Artist entities
      final artistList = artists
          .map((artist) => Artist(
                id: artist.id,
                name: artist.artist,
                albumIds: [],
                trackIds: [],
                numberOfAlbums: artist.numberOfAlbums ?? 0,
                numberOfTracks: artist.numberOfTracks ?? 0,
              ))
          .toList();

      return artistList;
    } catch (e) {
      _logger.error('Error scanning artists: $e');
      throw MediaScanException(message: 'Failed to scan artists: $e');
    }
  }

  /// Get tracks for a specific album
  Future<List<Track>> getTracksForAlbum(String albumId) async {
    try {
      _logger.info('Fetching tracks for album: $albumId');

      final tracks = await _audioQuery.querySongs(
        // albumId: int.parse(albumId),
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.INTERNAL,
      );

      final trackList = tracks
          .map((song) => Track(
                id: song.id,
                title: song.title,
                artist: song.artist ?? 'Unknown Artist',
                album: song.album ?? 'Unknown Album',
                duration: Duration(milliseconds: song.duration ?? 0),
                filePath: song.data,
                albumId: song.albumId?.toString(),
                artistId: song.artistId?.toString(),
              ))
          .toList();

      return trackList;
    } catch (e) {
      _logger.error('Error fetching tracks for album: $e');
      throw MediaScanException(message: 'Failed to fetch tracks for album: $e');
    }
  }

  /// Get tracks for a specific artist
  Future<List<Track>> getTracksForArtist(String artistId) async {
    try {
      _logger.info('Fetching tracks for artist: $artistId');

      final tracks = await _audioQuery.querySongs(
        // artistId: int.parse(artistId),
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.INTERNAL,
      );

      final trackList = tracks
          .map((song) => Track(
                id: song.id,
                title: song.title,
                artist: song.artist ?? 'Unknown Artist',
                album: song.album ?? 'Unknown Album',
                duration: Duration(milliseconds: song.duration ?? 0),
                filePath: song.data,
                albumId: song.albumId?.toString(),
                artistId: song.artistId?.toString(),
              ))
          .toList();

      return trackList;
    } catch (e) {
      _logger.error('Error fetching tracks for artist: $e');
      throw MediaScanException(message: 'Failed to fetch tracks for artist: $e');
    }
  }

  /// Search tracks by query string
  /// Searches in title, artist, and album fields
  /// Only searches tracks in External Storage > Music directory
  Future<List<Track>> searchTracks(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      _logger.info('Searching for tracks in External Storage Music directory: $query');

      final tracks = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      // Filter to Music directory tracks first
      final musicTracks = tracks.where((song) {
        final path = song.data.toLowerCase();
        return path.contains('/music/');
      }).toList();

      // Then filter based on query
      final filtered = musicTracks
          .where((song) =>
              (song.title.toLowerCase().contains(query.toLowerCase())) ||
              (song.artist?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (song.album?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();

      _logger.info('Search found ${filtered.length} results in External Storage Music directory');

      final trackList = <Track>[];
      for (final song in filtered) {
        final artwork = await getTrackArtwork(song.id);
        trackList.add(Track(
          id: song.id,
          title: song.title,
          artist: song.artist ?? 'Unknown Artist',
          album: song.album ?? 'Unknown Album',
          duration: Duration(milliseconds: song.duration ?? 0),
          filePath: song.data,
          albumId: song.albumId?.toString(),
          artistId: song.artistId?.toString(),
          artwork: artwork,
        ));
      }

      return trackList;
    } catch (e) {
      _logger.error('Error searching tracks: $e');
      throw MediaScanException(message: 'Failed to search tracks: $e');
    }
  }

  /// Get album artwork for a track
  /// Returns artwork as a int List (bytes)
  Future<List<int>?> getTrackArtwork(int trackId) async {
    try {
      final artwork = await _audioQuery.queryArtwork(
        trackId,
        ArtworkType.AUDIO,
      );
      return artwork;
    } catch (e) {
      _logger.error('Error fetching artwork: $e');
      return null;
    }
  }

  /// Get album artwork for an album
  /// Returns artwork as a int List (bytes)
  Future<List<int>?> getAlbumArtwork(int albumId) async {
    try {
      final artwork = await _audioQuery.queryArtwork(
        albumId,
        ArtworkType.ALBUM,
      );
      return artwork;
    } catch (e) {
      _logger.error('Error fetching album artwork: $e');
      return null;
    }
  }

  /// Get total count of audio files on device
  Future<int> getTrackCount() async {
    try {
      final tracks = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.INTERNAL,
      );
      return tracks.length;
    } catch (e) {
      _logger.error('Error getting track count: $e');
      return 0;
    }
  }
}

