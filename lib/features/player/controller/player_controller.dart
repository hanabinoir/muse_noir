import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/features/player/state/audio_state.dart';
import 'package:muse_noir/services/audio/audio_service.dart';

/// Controller for managing audio playback
class PlayerController {
  final AudioService audioService;
  final Ref ref;
  final AppLogger _logger = AppLogger();

  PlayerController({
    required this.audioService,
    required this.ref,
  });

  /// Play a single track
  Future<void> playTrack(Track track) async {
    try {
      _logger.info('Playing track: ${track.title}');

      // Update current track
      ref.read(currentTrackProvider.notifier).setCurrentTrack(track);

      // Set playlist with just this track
      ref.read(playlistProvider.notifier).setPlaylist([track]);

      // Play the track
      await audioService.playTrack(track);
    } catch (e, st) {
      _logger.error('Error playing track', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Play a playlist of tracks starting from a specific index
  Future<void> playPlaylist(List<Track> tracks, {int startIndex = 0}) async {
    try {
      if (tracks.isEmpty) {
        _logger.warning('Cannot play empty playlist');
        return;
      }

      _logger.info('Playing playlist with ${tracks.length} tracks from index $startIndex');

      // Update playlist
      ref.read(playlistProvider.notifier).setPlaylist(tracks);

      // Update current track
      ref.read(currentTrackProvider.notifier).setCurrentTrack(tracks[startIndex]);

      // Play the playlist
      await audioService.playPlaylist(tracks, startIndex: startIndex);
    } catch (e, st) {
      _logger.error('Error playing playlist', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      _logger.info('Pausing playback');
      await audioService.pause();
    } catch (e, st) {
      _logger.error('Error pausing playback', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      _logger.info('Resuming playback');
      await audioService.resume();
    } catch (e, st) {
      _logger.error('Error resuming playback', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Toggle between play and pause
  Future<void> togglePlayPause() async {
    try {
      if (audioService.isPlaying) {
        await pause();
      } else {
        await resume();
      }
    } catch (e, st) {
      _logger.error('Error toggling play/pause', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Stop playback
  Future<void> stop() async {
    try {
      _logger.info('Stopping playback');
      await audioService.stop();
      ref.read(currentTrackProvider.notifier).clearCurrentTrack();
      ref.read(playlistProvider.notifier).clearPlaylist();
    } catch (e, st) {
      _logger.error('Error stopping playback', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      _logger.info('Seeking to ${position.inSeconds}s');
      await audioService.seek(position);
    } catch (e, st) {
      _logger.error('Error seeking', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Play next track
  Future<void> next() async {
    try {
      _logger.info('Playing next track');
      await audioService.next();

      // Update current track if available
      final currentIndex = audioService.currentIndex;
      final playlist = ref.read(playlistProvider);

      if (currentIndex < playlist.length) {
        ref.read(currentTrackProvider.notifier).setCurrentTrack(playlist[currentIndex]);
      }
    } catch (e, st) {
      _logger.error('Error playing next track', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Play previous track
  Future<void> previous() async {
    try {
      _logger.info('Playing previous track');
      await audioService.previous();

      // Update current track if available
      final currentIndex = audioService.currentIndex;
      final playlist = ref.read(playlistProvider);

      if (currentIndex < playlist.length) {
        ref.read(currentTrackProvider.notifier).setCurrentTrack(playlist[currentIndex]);
      }
    } catch (e, st) {
      _logger.error('Error playing previous track', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Toggle shuffle mode
  Future<void> toggleShuffle() async {
    try {
      _logger.info('Toggling shuffle mode');
      await ref.read(shuffleModeProvider.notifier).toggleShuffleMode();
    } catch (e, st) {
      _logger.error('Error toggling shuffle', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Toggle loop mode
  Future<void> toggleLoop() async {
    try {
      _logger.info('Toggling loop mode');
      await ref.read(loopModeProvider.notifier).toggleLoopMode();
    } catch (e, st) {
      _logger.error('Error toggling loop', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    try {
      _logger.info('Setting playback speed to $speed');
      await ref.read(playbackSpeedProvider.notifier).setSpeed(speed);
    } catch (e, st) {
      _logger.error('Error setting playback speed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      _logger.info('Disposing PlayerController');
      await audioService.dispose();
    } catch (e, st) {
      _logger.error('Error disposing PlayerController', error: e, stackTrace: st);
    }
  }
}

/// Provider for the player controller
final playerControllerProvider = Provider((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return PlayerController(
    audioService: audioService,
    ref: ref,
  );
});

