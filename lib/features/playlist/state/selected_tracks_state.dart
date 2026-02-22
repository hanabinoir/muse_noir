import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/utils/logger.dart';

/// State notifier for managing track selections in add-to-playlist dialog
class SelectedTracksNotifier extends Notifier<Set<int>> {
  final AppLogger _logger = AppLogger();

  @override
  Set<int> build() {
    return {};
  }

  /// Add a track to selection
  void addTrack(int trackId) {
    state = {...state, trackId};
    _logger.info('Added track $trackId to selection. Total: ${state.length}');
  }

  /// Remove a track from selection
  void removeTrack(int trackId) {
    state = state.where((id) => id != trackId).toSet();
    _logger.info('Removed track $trackId from selection. Total: ${state.length}');
  }

  /// Toggle track selection
  void toggleTrack(int trackId) {
    if (state.contains(trackId)) {
      removeTrack(trackId);
    } else {
      addTrack(trackId);
    }
  }

  /// Clear all selections
  void clearSelection() {
    state = {};
    _logger.info('Cleared all track selections');
  }

  /// Check if a track is selected
  bool isSelected(int trackId) {
    return state.contains(trackId);
  }

  /// Get total selected count
  int getSelectedCount() {
    return state.length;
  }

  /// Get selected track IDs as list
  List<int> getSelectedTracks() {
    return state.toList();
  }
}

/// Provider for managing selected tracks
final selectedTracksProvider =
    NotifierProvider<SelectedTracksNotifier, Set<int>>(() {
  return SelectedTracksNotifier();
});

