import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Playlist state for managing playlist operations
class PlaylistState {
  final bool isLoading;
  final String? error;

  const PlaylistState({
    this.isLoading = false,
    this.error,
  });

  PlaylistState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return PlaylistState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Playlist state notifier
class PlaylistStateNotifier extends Notifier<PlaylistState> {
  @override
  PlaylistState build() {
    return const PlaylistState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Playlist state provider
final playlistStateProvider =
    NotifierProvider<PlaylistStateNotifier, PlaylistState>(() {
  return PlaylistStateNotifier();
});


