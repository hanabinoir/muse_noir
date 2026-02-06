/// Album entity representing a collection of tracks
class Album {
  final int id;
  final String title;
  final String artist;
  final List<int> trackIds;
  final String? albumArt;
  final int? year;
  final int numOfSongs;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.trackIds,
    this.albumArt,
    this.year,
    required this.numOfSongs,
  });

  /// Create a copy with modified fields
  Album copyWith({
    int? id,
    String? title,
    String? artist,
    List<int>? trackIds,
    String? albumArt,
    int? year,
    int? numOfSongs,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      trackIds: trackIds ?? this.trackIds,
      albumArt: albumArt ?? this.albumArt,
      year: year ?? this.year,
      numOfSongs: numOfSongs ?? this.numOfSongs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Album(id: $id, title: $title, artist: $artist, numOfSongs: $numOfSongs)';
  }
}

