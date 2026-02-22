import 'package:flutter/material.dart';

/// Track tile widget for album display - shows track number instead of artwork
class AlbumTrackTile extends StatelessWidget {
  final int trackNumber;
  final String title;
  final String artist;
  final String? duration;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const AlbumTrackTile({
    super.key,
    required this.trackNumber,
    required this.title,
    required this.artist,
    this.duration,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        trackNumber.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.purple,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: duration != null
          ? Text(
              duration!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            )
          : null,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

