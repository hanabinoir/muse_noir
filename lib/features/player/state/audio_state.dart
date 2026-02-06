import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/features/player/state/playback_state_enum.dart';
import 'package:muse_noir/services/audio/audio_service.dart';

// Audio service singleton provider
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

// Current playback state provider
final playbackStateProvider = StreamProvider<PlaybackState>((ref) {
  final audioService = ref.watch(audioServiceProvider);

  return audioService.playerStateStream.map((state) {
    if (state.playing) {
      return PlaybackState.playing;
    } else if (state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering) {
      return PlaybackState.loading;
    } else {
      return PlaybackState.paused;
    }
  });
});

// Current playback position stream provider
final positionProvider = StreamProvider<Duration>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.positionStream;
});

// Current track duration stream provider
final durationProvider = StreamProvider<Duration?>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.durationStream;
});

// Current track index in playlist
final currentIndexProvider = StreamProvider<int?>((ref) {
  final audioService = ref.watch(audioServiceProvider);

  return audioService.sequenceStateStream.map((state) {
    return state?.currentIndex;
  });
});

// Current playing track notifier
class CurrentTrackNotifier extends Notifier<Track?> {
  @override
  Track? build() {
    return null;
  }

  void setCurrentTrack(Track? track) {
    state = track;
  }

  void clearCurrentTrack() {
    state = null;
  }
}

final currentTrackProvider = NotifierProvider<CurrentTrackNotifier, Track?>(() {
  return CurrentTrackNotifier();
});

// Current playlist notifier
class PlaylistNotifier extends Notifier<List<Track>> {
  @override
  List<Track> build() {
    return [];
  }

  void setPlaylist(List<Track> tracks) {
    state = tracks;
  }

  void addTrack(Track track) {
    state = [...state, track];
  }

  void removeTrack(Track track) {
    state = state.where((t) => t.id != track.id).toList();
  }

  void clearPlaylist() {
    state = [];
  }
}

final playlistProvider = NotifierProvider<PlaylistNotifier, List<Track>>(() {
  return PlaylistNotifier();
});

// Loop mode notifier
class LoopModeNotifier extends Notifier<LoopMode> {
  late AudioService _audioService;

  @override
  LoopMode build() {
    _audioService = ref.watch(audioServiceProvider);
    return LoopMode.off;
  }

  Future<void> toggleLoopMode() async {
    final nextMode = switch (state) {
      LoopMode.off => LoopMode.one,
      LoopMode.one => LoopMode.all,
      LoopMode.all => LoopMode.off,
    };

    await _audioService.setLoopMode(nextMode);
    state = nextMode;
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _audioService.setLoopMode(mode);
    state = mode;
  }
}

final loopModeProvider = NotifierProvider<LoopModeNotifier, LoopMode>(() {
  return LoopModeNotifier();
});

// Shuffle mode notifier
class ShuffleModeNotifier extends Notifier<bool> {
  late AudioService _audioService;

  @override
  bool build() {
    _audioService = ref.watch(audioServiceProvider);
    return false;
  }

  Future<void> toggleShuffleMode() async {
    final newValue = !state;
    await _audioService.setShuffleModeEnabled(newValue);
    state = newValue;
  }

  Future<void> setShuffleMode(bool enabled) async {
    await _audioService.setShuffleModeEnabled(enabled);
    state = enabled;
  }
}

final shuffleModeProvider = NotifierProvider<ShuffleModeNotifier, bool>(() {
  return ShuffleModeNotifier();
});

// Playback speed notifier
class PlaybackSpeedNotifier extends Notifier<double> {
  late AudioService _audioService;

  @override
  double build() {
    _audioService = ref.watch(audioServiceProvider);
    return 1.0;
  }

  Future<void> setSpeed(double speed) async {
    if (speed < 0.5 || speed > 2.0) {
      return; // Ignore invalid speeds
    }
    await _audioService.setSpeed(speed);
    state = speed;
  }
}

final playbackSpeedProvider = NotifierProvider<PlaybackSpeedNotifier, double>(() {
  return PlaybackSpeedNotifier();
});
