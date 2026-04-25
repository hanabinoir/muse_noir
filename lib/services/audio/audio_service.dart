import 'package:media_kit/media_kit.dart' as mk;
import 'package:muse_noir/core/errors/app_exception.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/track.dart';

/// Service for audio playback using media_kit
class AudioService {
  final mk.Player _player = mk.Player();
  final AppLogger _logger = AppLogger();

  List<Track> _currentPlaylist = [];
  int _currentIndex = 0;

  /// Get the underlying Player instance
  mk.Player get player => _player;

  /// Get stream of current player state (for compatibility)
  mk.PlayerStream get playerStateStream => _player.stream;

  /// Get stream of current playback position
  Stream<Duration> get positionStream => _player.stream.position;

  /// Get stream of current track duration
  Stream<Duration> get durationStream => _player.stream.duration;

  /// Get current playback position
  Duration get currentPosition => _player.state.position;

  /// Get current track duration
  Duration get duration => _player.state.duration;

  /// Check if currently playing
  bool get isPlaying => _player.state.playing;

  /// Play a track from the given file path
  Future<void> playTrack(Track track) async {
    try {
      _logger.info('Playing track: ${track.title}');

      // Update current playlist and index
      _currentPlaylist = [track];
      _currentIndex = 0;

      // Create a Media object from the track file path
      final media = mk.Media(track.filePath);

      // Open and play the media
      await _player.open(media, play: true);

      _logger.info('Successfully started playing: ${track.title}');
    } catch (e, st) {
      _logger.error('Failed to play track: ${track.title}', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to play track: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Play a list of tracks starting from the specified index
  Future<void> playPlaylist(List<Track> tracks, {int startIndex = 0}) async {
    try {
      if (tracks.isEmpty) {
        throw AudioPlaybackException(
          message: 'Cannot play empty playlist',
        );
      }

      _logger.info('Playing playlist with ${tracks.length} tracks, starting at index $startIndex');

      // Update current playlist and index
      _currentPlaylist = tracks;
      _currentIndex = startIndex;

      // Create Media objects from all tracks
      final mediaList = tracks.map((track) => mk.Media(track.filePath)).toList();

      // Create a Playlist with the media items
      final playlist = mk.Playlist(mediaList, index: startIndex);

      // Open and play the playlist
      await _player.open(playlist, play: true);

      _logger.info('Successfully started playing playlist from index $startIndex');
    } catch (e, st) {
      _logger.error('Failed to play playlist', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to play playlist: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      _logger.info('Pausing playback');
      await _player.pause();
    } catch (e, st) {
      _logger.error('Failed to pause playback', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to pause: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      _logger.info('Resuming playback');
      await _player.play();
    } catch (e, st) {
      _logger.error('Failed to resume playback', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to resume: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Stop playback and release resources
  Future<void> stop() async {
    try {
      _logger.info('Stopping playback');
      await _player.stop();
    } catch (e, st) {
      _logger.error('Failed to stop playback', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to stop: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      _logger.info('Seeking to position: ${position.inSeconds}s');
      await _player.seek(position);
    } catch (e, st) {
      _logger.error('Failed to seek', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to seek: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Play next track in the playlist
  Future<void> next() async {
    try {
      _logger.info('Playing next track');
      await _player.next();
      if (_currentIndex < _currentPlaylist.length - 1) {
        _currentIndex++;
      }
    } catch (e, st) {
      _logger.error('Failed to skip to next track', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to skip to next: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Play previous track in the playlist
  Future<void> previous() async {
    try {
      _logger.info('Playing previous track');
      await _player.previous();
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    } catch (e, st) {
      _logger.error('Failed to skip to previous track', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to skip to previous: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Set the playback speed
  Future<void> setSpeed(double speed) async {
    try {
      _logger.info('Setting playback speed to $speed');
      await _player.setRate(speed);
    } catch (e, st) {
      _logger.error('Failed to set playback speed', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to set speed: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Set the loop mode
  Future<void> setLoopMode(mk.PlaylistMode mode) async {
    try {
      _logger.info('Setting loop mode to $mode');
      await _player.setPlaylistMode(mode);
    } catch (e, st) {
      _logger.error('Failed to set loop mode', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to set loop mode: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Set shuffle mode
  Future<void> setShuffleModeEnabled(bool enabled) async {
    try {
      _logger.info('Setting shuffle mode to $enabled');
      await _player.setShuffle(enabled);
    } catch (e, st) {
      _logger.error('Failed to set shuffle mode', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to set shuffle mode: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Get current index in playlist
  int get currentIndex => _currentIndex;

  /// Get playlist stream
  Stream<mk.Playlist> get playlistStream => _player.stream.playlist;

  /// Dispose the audio player and release resources
  Future<void> dispose() async {
    try {
      _logger.info('Disposing AudioService');
      await _player.dispose();
      _logger.info('AudioService disposed successfully');
    } catch (e, st) {
      _logger.error('Error disposing AudioService', error: e, stackTrace: st);
    }
  }
}

