import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/library/state/library_providers.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// Controller for library operations
/// Manages complex interactions with library state
class LibraryController {
  final Ref _ref;
  final AppLogger _appLogger = AppLogger();

  LibraryController(this._ref);

  /// Load all tracks
  Future<void> loadAllTracks() async {
    try {
      _appLogger.info('LibraryController: Loading all tracks');
      final notifier = _ref.read(allTracksProvider.notifier);
      await notifier.fetchAllTracks();
    } catch (e) {
      _appLogger.error('LibraryController: Error loading tracks: $e');
      rethrow;
    }
  }

  /// Load all albums
  Future<void> loadAllAlbums() async {
    try {
      _appLogger.info('LibraryController: Loading all albums');
      final notifier = _ref.read(allAlbumsProvider.notifier);
      await notifier.fetchAllAlbums();
    } catch (e) {
      _appLogger.error('LibraryController: Error loading albums: $e');
      rethrow;
    }
  }

  /// Load all artists
  Future<void> loadAllArtists() async {
    try {
      _appLogger.info('LibraryController: Loading all artists');
      final notifier = _ref.read(allArtistsProvider.notifier);
      await notifier.fetchAllArtists();
    } catch (e) {
      _appLogger.error('LibraryController: Error loading artists: $e');
      rethrow;
    }
  }

  /// Load all library data (tracks, albums, artists)
  Future<void> loadLibrary() async {
    try {
      _appLogger.info('LibraryController: Loading entire library');
      await Future.wait([
        loadAllTracks(),
        loadAllAlbums(),
        loadAllArtists(),
      ]);
    } catch (e) {
      _appLogger.error('LibraryController: Error loading library: $e');
      rethrow;
    }
  }

  /// Search for tracks
  Future<void> searchTracks(String query) async {
    try {
      _appLogger.info('LibraryController: Searching for: $query');
      // _ref.read(searchQueryProvider.notifier).state = query;

      final notifier = _ref.read(searchProvider.notifier);
      await notifier.searchTracks(query);
    } catch (e) {
      _appLogger.error('LibraryController: Error searching: $e');
      rethrow;
    }
  }

  /// Clear search results
  void clearSearch() {
    _appLogger.info('LibraryController: Clearing search');
    // _ref.read(searchQueryProvider.notifier).state = '';
    _ref.read(searchProvider.notifier).clearSearch();
  }

  /// Get number of tracks
  int getTrackCount() {
    return _ref.read(allTracksProvider).length;
  }

  /// Get number of albums
  int getAlbumCount() {
    return _ref.read(allAlbumsProvider).length;
  }

  /// Get number of artists
  int getArtistCount() {
    return _ref.read(allArtistsProvider).length;
  }
}

/// Provider for library controller
final libraryControllerProvider = Provider((ref) {
  return LibraryController(ref);
});

