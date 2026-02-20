import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Favorites state for managing favorite tracks
class FavoritesState {
  final List<String> favoriteTrackIds;

  const FavoritesState({
    this.favoriteTrackIds = const [],
  });

  FavoritesState copyWith({
    List<String>? favoriteTrackIds,
  }) {
    return FavoritesState(
      favoriteTrackIds: favoriteTrackIds ?? this.favoriteTrackIds,
    );
  }

  bool isFavorite(String trackId) {
    return favoriteTrackIds.contains(trackId);
  }
}

/// Favorites state notifier
class FavoritesStateNotifier extends Notifier<FavoritesState> {
  @override
  FavoritesState build() {
    return const FavoritesState();
  }

  void addFavorite(String trackId) {
    if (!state.favoriteTrackIds.contains(trackId)) {
      state = state.copyWith(
        favoriteTrackIds: [...state.favoriteTrackIds, trackId],
      );
    }
  }

  void removeFavorite(String trackId) {
    state = state.copyWith(
      favoriteTrackIds: state.favoriteTrackIds
          .where((id) => id != trackId)
          .toList(),
    );
  }

  void toggleFavorite(String trackId) {
    if (state.isFavorite(trackId)) {
      removeFavorite(trackId);
    } else {
      addFavorite(trackId);
    }
  }
}

/// Favorites state provider
final favoritesStateProvider =
    NotifierProvider<FavoritesStateNotifier, FavoritesState>(() {
  return FavoritesStateNotifier();
});


