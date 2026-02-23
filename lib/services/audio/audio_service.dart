import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:muse_noir/core/errors/app_exception.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/domain/entities/track.dart';

/// Service for audio playback using just_audio
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AppLogger _logger = AppLogger();

  /// Get the underlying AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  /// Get stream of current player state
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Get stream of current playback position
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Get stream of current track duration
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// Get current playback state
  PlayerState? get currentState => _audioPlayer.playerState;

  /// Get current playback position
  Duration get currentPosition => _audioPlayer.position;

  /// Get current track duration
  Duration? get duration => _audioPlayer.duration;

  /// Check if currently playing
  bool get isPlaying => _audioPlayer.playing;

  /// Initialize the audio player
  Future<void> initialize() async {
    try {
      // Configure just_audio_background for lock screen notifications
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.muse_noir.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      );
      _logger.info('Initializing AudioService');
      // JustAudioBackground is already initialized in main.dart
      _logger.info('AudioService initialized successfully');
    } catch (e, st) {
      _logger.error('Failed to initialize AudioService', error: e, stackTrace: st);
      throw AudioPlaybackException(
        message: 'Failed to initialize audio player: $e',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Play a track from the given file path
  Future<void> playTrack(Track track) async {
    try {
      _logger.info('Playing track: ${track.title}');

      // Set audio source to the track file with metadata for lock screen
      await _audioPlayer.setAudioSource(
        AudioSource.file(
          track.filePath,
          tag: MediaItem(
            id: track.id.toString(),
            title: track.title,
            artist: track.artist,
            album: track.album,
            duration: track.duration,
          ),
        ),
      );

      // Start playback
      await _audioPlayer.play();

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

      // Create audio sources from all tracks with metadata for lock screen
      final audioSources = tracks
          .map((track) => AudioSource.file(
            track.filePath,
            tag: MediaItem(
              id: track.id.toString(),
              title: track.title,
              artist: track.artist,
              album: track.album,
              duration: track.duration,
            ),
          ))
          .toList();

      // Set the playlist
      await _audioPlayer.setAudioSources(
        audioSources,
        initialIndex: startIndex,
        initialPosition: Duration.zero,
      );

      // Start playback
      await _audioPlayer.play();

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
      await _audioPlayer.pause();
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
      await _audioPlayer.play();
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
      await _audioPlayer.stop();
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
      await _audioPlayer.seek(position);
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
      await _audioPlayer.seekToNext();
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
      await _audioPlayer.seekToPrevious();
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
      await _audioPlayer.setSpeed(speed);
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
  Future<void> setLoopMode(LoopMode mode) async {
    try {
      _logger.info('Setting loop mode to $mode');
      await _audioPlayer.setLoopMode(mode);
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
      await _audioPlayer.setShuffleModeEnabled(enabled);
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
  int? get currentIndex => _audioPlayer.currentIndex;

  /// Get sequence state stream
  Stream<SequenceState?> get sequenceStateStream => _audioPlayer.sequenceStateStream;

  /// Dispose the audio player and release resources
  Future<void> dispose() async {
    try {
      _logger.info('Disposing AudioService');
      await _audioPlayer.dispose();
      _logger.info('AudioService disposed successfully');
    } catch (e, st) {
      _logger.error('Error disposing AudioService', error: e, stackTrace: st);
    }
  }
}

