import 'package:hive/hive.dart';
import 'package:muse_noir/domain/entities/playlist.dart';

/// Hive adapter for Playlist entity
class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 5; // Unique ID for this type

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return Playlist(
      id: fields[0] as String,
      name: fields[1] as String,
      trackIds: (fields[2] as List).cast<int>(),
      dateCreated: fields[3] as DateTime,
      dateModified: fields[4] as DateTime,
      description: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.trackIds);
    writer.writeByte(3);
    writer.write(obj.dateCreated);
    writer.writeByte(4);
    writer.write(obj.dateModified);
    writer.writeByte(5);
    writer.write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

