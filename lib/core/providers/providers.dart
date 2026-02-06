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
import 'package:muse_noir/services/audio/audio_service.dart';
import 'package:muse_noir/services/media/media_scanner.dart';
import 'package:muse_noir/services/media/media_library_service.dart';
import 'package:muse_noir/services/permissions/permission_service.dart';
import 'package:muse_noir/data/datasources/local_media_datasource.dart';
import 'package:muse_noir/data/repositories/media_repository.dart' as media_repo_impl;

// Audio Service (Phase 2)
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

// Permission Service (Phase 3)
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

// Media Scanner Service (Phase 3)
final mediaScannerProvider = Provider<MediaScannerService>((ref) {
  return MediaScannerService();
});

// Media Library Service (Phase 3)
final mediaLibraryServiceProvider = Provider<MediaLibraryService>((ref) {
  final permissionService = ref.watch(permissionServiceProvider);
  final mediaScanner = ref.watch(mediaScannerProvider);
  return MediaLibraryService(permissionService, mediaScanner);
});

// Local Media Data Source (Phase 3)
final localMediaDataSourceProvider = Provider<LocalMediaDataSource>((ref) {
  final mediaScanner = ref.watch(mediaScannerProvider);
  return LocalMediaDataSource(mediaScanner);
});

/// Provider for MediaRepository
final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  final localDataSource = ref.watch(localMediaDataSourceProvider);
  return media_repo_impl.MediaRepositoryImpl(localDataSource);
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

