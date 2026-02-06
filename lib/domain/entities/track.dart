/// Track entity representing a music file
class Track {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final Duration duration;
  final String? albumArtist;
  final String? genre;
  final DateTime? dateAdded;
  final int? dateModified;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    this.albumArtist,
    this.genre,
    this.dateAdded,
    this.dateModified,
  });

  /// Create a copy with modified fields
  Track copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    Duration? duration,
    String? albumArtist,
    String? genre,
    DateTime? dateAdded,
    int? dateModified,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      albumArtist: albumArtist ?? this.albumArtist,
      genre: genre ?? this.genre,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Track &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          filePath == other.filePath;

  @override
  int get hashCode => id.hashCode ^ filePath.hashCode;

  @override
  String toString() {
    return 'Track(id: $id, title: $title, artist: $artist, album: $album)';
  }
}

