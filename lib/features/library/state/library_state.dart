import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/core/providers/providers.dart';

/// State notifier for managing library tracks
class LibraryNotifier extends Notifier<List<Track>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Track> build() {
    return [];
  }

  /// Fetch all tracks from device
  Future<void> fetchAllTracks() async {
    try {
      _logger.info('Fetching all tracks...');
      final getAllTracksUsecase = ref.watch(getAllTracksUsecaseProvider);
      state = await getAllTracksUsecase.call();
      _logger.info('Fetched ${state.length} tracks');
    } catch (e, stackTrace) {
      _logger.error('Error fetching tracks: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing albums
class AlbumNotifier extends Notifier<List<Album>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Album> build() {
    return [];
  }

  /// Fetch all albums from device
  Future<void> fetchAllAlbums() async {
    try {
      _logger.info('Fetching all albums...');
      final getAllAlbumsUsecase = ref.watch(getAllAlbumsUsecaseProvider);
      state = await getAllAlbumsUsecase.call();
      _logger.info('Fetched ${state.length} albums');
    } catch (e, stackTrace) {
      _logger.error('Error fetching albums: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing artists
class ArtistNotifier extends Notifier<List<Artist>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Artist> build() {
    return [];
  }

  /// Fetch all artists from device
  Future<void> fetchAllArtists() async {
    try {
      _logger.info('Fetching all artists...');
      final getAllArtistsUsecase = ref.watch(getAllArtistsUsecaseProvider);
      state = await getAllArtistsUsecase.call();
      _logger.info('Fetched ${state.length} artists');
    } catch (e, stackTrace) {
      _logger.error('Error fetching artists: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing tracks from a specific album
class AlbumTracksNotifier extends Notifier<List<Track>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Track> build() {
    return [];
  }

  /// Fetch tracks for a specific album
  Future<void> fetchTracksForAlbum(String albumId) async {
    try {
      _logger.info('Fetching tracks for album: $albumId');
      final getTracksForAlbumUsecase = ref.watch(getTracksForAlbumUsecaseProvider);
      state = await getTracksForAlbumUsecase.call(albumId);
      _logger.info('Fetched ${state.length} tracks for album');
    } catch (e, stackTrace) {
      _logger.error('Error fetching album tracks: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing tracks from a specific artist
class ArtistTracksNotifier extends Notifier<List<Track>> {
  final AppLogger _logger = AppLogger();

  @override
  List<Track> build() {
    return [];
  }

  /// Fetch tracks for a specific artist
  Future<void> fetchTracksForArtist(String artistId) async {
    try {
      _logger.info('Fetching tracks for artist: $artistId');
      final getTracksForArtistUsecase = ref.watch(getTracksForArtistUsecaseProvider);
      state = await getTracksForArtistUsecase.call(artistId);
      _logger.info('Fetched ${state.length} tracks for artist');
    } catch (e, stackTrace) {
      _logger.error('Error fetching artist tracks: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// Tracks provider
final tracksProvider = NotifierProvider<LibraryNotifier, List<Track>>(() {
  return LibraryNotifier();
});

/// Albums provider
final albumsProvider = NotifierProvider<AlbumNotifier, List<Album>>(() {
  return AlbumNotifier();
});

/// Artists provider
final artistsProvider = NotifierProvider<ArtistNotifier, List<Artist>>(() {
  return ArtistNotifier();
});

/// Album tracks provider
final albumTracksProvider = NotifierProvider<AlbumTracksNotifier, List<Track>>(() {
  return AlbumTracksNotifier();
});

/// Artist tracks provider
final artistTracksProvider = NotifierProvider<ArtistTracksNotifier, List<Track>>(() {
  return ArtistTracksNotifier();
});

/// Search query provider for text input
// final searchQueryProvider = NotifierProvider<String>(() {
//   return '';
// });

