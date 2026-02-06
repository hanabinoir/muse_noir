import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/domain/repositories/media_repository.dart';
import 'package:muse_noir/domain/repositories/playlist_repository.dart';
import 'package:muse_noir/domain/usecases/add_track_to_playlist_usecase.dart';
import 'package:muse_noir/domain/usecases/create_playlist_usecase.dart';
import 'package:muse_noir/domain/usecases/delete_playlist_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_albums_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_artists_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_playlists_usecase.dart';
import 'package:muse_noir/domain/usecases/get_all_tracks_usecase.dart';
import 'package:muse_noir/domain/usecases/remove_track_from_playlist_usecase.dart';
import 'package:muse_noir/domain/usecases/search_tracks_usecase.dart';

// TODO: Implement repository instances (will be done in Phase 3-4)

/// Provider for MediaRepository
final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  throw UnimplementedError('MediaRepository not yet implemented');
});

/// Provider for PlaylistRepository
final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  throw UnimplementedError('PlaylistRepository not yet implemented');
});

// Use cases

/// Provider for GetAllTracksUsecase
final getAllTracksUsecaseProvider = Provider((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  return GetAllTracksUsecase(repository);
});

/// Provider for GetAllAlbumsUsecase
final getAllAlbumsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  return GetAllAlbumsUsecase(repository);
});

/// Provider for GetAllArtistsUsecase
final getAllArtistsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  return GetAllArtistsUsecase(repository);
});

/// Provider for SearchTracksUsecase
final searchTracksUsecaseProvider = Provider((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  return SearchTracksUsecase(repository);
});

/// Provider for CreatePlaylistUsecase
final createPlaylistUsecaseProvider = Provider((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return CreatePlaylistUsecase(repository);
});

/// Provider for GetAllPlaylistsUsecase
final getAllPlaylistsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return GetAllPlaylistsUsecase(repository);
});

/// Provider for AddTrackToPlaylistUsecase
final addTrackToPlaylistUsecaseProvider = Provider((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return AddTrackToPlaylistUsecase(repository);
});

/// Provider for RemoveTrackFromPlaylistUsecase
final removeTrackFromPlaylistUsecaseProvider = Provider((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return RemoveTrackFromPlaylistUsecase(repository);
});

/// Provider for DeletePlaylistUsecase
final deletePlaylistUsecaseProvider = Provider((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return DeletePlaylistUsecase(repository);
});

