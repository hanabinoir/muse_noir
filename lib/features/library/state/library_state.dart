import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/domain/usecases/get_all_tracks_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_albums_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_artists_usecase.dart';
import 'package:muse_noir/domain/usecases/search_tracks_usecase.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/core/providers/providers.dart';

/// State notifier for managing library tracks
class LibraryNotifier extends Notifier<List<Track>> {
  late GetAllTracksUseCase _getAllTracksUseCase;
  final AppLogger _logger = AppLogger();

  @override
  List<Track> build() {
    _getAllTracksUseCase = ref.watch(getAllTracksUsecaseProvider);
    return [];
  }

  /// Fetch all tracks
  Future<void> fetchAllTracks() async {
    try {
      state = await _getAllTracksUseCase.call();
      _logger.info('Fetched ${state.length} tracks');
    } catch (e, stackTrace) {
      _logger.error('Error fetching tracks: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing albums
class AlbumNotifier extends Notifier<List<Album>> {
  late GetAllAlbumsUseCase _getAllAlbumsUseCase;
  final AppLogger _logger = AppLogger();

  @override
  List<Album> build() {
    _getAllAlbumsUseCase = ref.watch(getAllAlbumsUsecaseProvider);
    return [];
  }

  /// Fetch all albums
  Future<void> fetchAllAlbums() async {
    try {
      state = await _getAllAlbumsUseCase.call();
      _logger.info('Fetched ${state.length} albums');
    } catch (e, stackTrace) {
      _logger.error('Error fetching albums: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing artists
class ArtistNotifier extends Notifier<List<Artist>> {
  late GetAllArtistsUseCase _getAllArtistsUseCase;
  final AppLogger _logger = AppLogger();

  @override
  List<Artist> build() {
    _getAllArtistsUseCase = ref.watch(getAllArtistsUsecaseProvider);
    return [];
  }

  /// Fetch all artists
  Future<void> fetchAllArtists() async {
    try {
      state = await _getAllArtistsUseCase.call();
      _logger.info('Fetched ${state.length} artists');
    } catch (e, stackTrace) {
      _logger.error('Error fetching artists: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

/// State notifier for managing search results
class SearchNotifier extends Notifier<List<Track>> {
  late SearchTracksUseCase _searchTracksUseCase;
  final AppLogger _logger = AppLogger();

  @override
  List<Track> build() {
    _searchTracksUseCase = ref.watch(searchTracksUsecaseProvider);
    return [];
  }

  /// Search tracks by query
  Future<void> searchTracks(String query) async {
    try {
      if (query.isEmpty) {
        state = [];
        return;
      }
      state = await _searchTracksUseCase.call(query);
      _logger.info('Search found ${state.length} results for: $query');
    } catch (e, stackTrace) {
      _logger.error('Error searching tracks: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Clear search results
  void clearSearch() {
    state = [];
  }
}

