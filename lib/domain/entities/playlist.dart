/// Playlist entity representing a user-created collection of tracks
class Playlist {
  final String id;
  final String name;
  final List<int> trackIds;
  final DateTime dateCreated;
  final DateTime dateModified;
  final String? description;

  const Playlist({
    required this.id,
    required this.name,
    required this.trackIds,
    required this.dateCreated,
    required this.dateModified,
    this.description,
  });

  /// Get the number of tracks in the playlist
  int get trackCount => trackIds.length;

  /// Create a copy with modified fields
  Playlist copyWith({
    String? id,
    String? name,
    List<int>? trackIds,
    DateTime? dateCreated,
    DateTime? dateModified,
    String? description,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      trackIds: trackIds ?? this.trackIds,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      description: description ?? this.description,
    );
  }

  /// Add a track to the playlist
  Playlist addTrack(int trackId) {
    if (trackIds.contains(trackId)) {
      return this;
    }
    return copyWith(
      trackIds: [...trackIds, trackId],
      dateModified: DateTime.now(),
    );
  }

  /// Remove a track from the playlist
  Playlist removeTrack(int trackId) {
    return copyWith(
      trackIds: trackIds.where((id) => id != trackId).toList(),
      dateModified: DateTime.now(),
    );
  }

  /// Clear all tracks from the playlist
  Playlist clear() {
    return copyWith(
      trackIds: [],
      dateModified: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Playlist &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, trackCount: $trackCount)';
  }
}

