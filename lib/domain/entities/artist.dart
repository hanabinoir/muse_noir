/// Artist entity representing a music artist
class Artist {
  final int id;
  final String name;
  final List<int> albumIds;
  final List<int> trackIds;
  final int numberOfAlbums;
  final int numberOfTracks;

  const Artist({
    required this.id,
    required this.name,
    required this.albumIds,
    required this.trackIds,
    required this.numberOfAlbums,
    required this.numberOfTracks,
  });

  /// Create a copy with modified fields
  Artist copyWith({
    int? id,
    String? name,
    List<int>? albumIds,
    List<int>? trackIds,
    int? numberOfAlbums,
    int? numberOfTracks,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      albumIds: albumIds ?? this.albumIds,
      trackIds: trackIds ?? this.trackIds,
      numberOfAlbums: numberOfAlbums ?? this.numberOfAlbums,
      numberOfTracks: numberOfTracks ?? this.numberOfTracks,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Artist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, numberOfAlbums: $numberOfAlbums, numberOfTracks: $numberOfTracks)';
  }
}

