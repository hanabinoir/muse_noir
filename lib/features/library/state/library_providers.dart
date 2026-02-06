import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/core/providers/providers.dart';

/// Provider for managing all tracks
final allTracksProvider =
    NotifierProvider<LibraryNotifier, List<Track>>(() {
  return LibraryNotifier();
});

/// Provider for managing all albums
final allAlbumsProvider =
    NotifierProvider<AlbumNotifier, List<Album>>(() {
  return AlbumNotifier();
});

/// Provider for managing all artists
final allArtistsProvider =
    NotifierProvider<ArtistNotifier, List<Artist>>(() {
  return ArtistNotifier();
});

/// Provider for search functionality
final searchProvider =
    NotifierProvider<SearchNotifier, List<Track>>(() {
  return SearchNotifier();
});

/// Provider for search query input
// final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
//   return SearchQueryNotifier();
// });


