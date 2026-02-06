/// Enum representing playback states
enum PlaybackState {
  /// Not playing any audio
  stopped,

  /// Currently playing audio
  playing,

  /// Audio is paused
  paused,

  /// Audio is loading/buffering
  loading,

  /// An error occurred during playback
  error,
}

/// Extension on PlaybackState for utility methods
extension PlaybackStateExtension on PlaybackState {
  /// Check if currently in a playing state
  bool get isPlaying => this == PlaybackState.playing;

  /// Check if currently paused
  bool get isPaused => this == PlaybackState.paused;

  /// Check if currently loading
  bool get isLoading => this == PlaybackState.loading;

  /// Check if in error state
  bool get hasError => this == PlaybackState.error;

  /// Check if stopped
  bool get isStopped => this == PlaybackState.stopped;
}

