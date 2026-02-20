import 'package:flutter/material.dart';

/// Playlist track tile widget
class PlaylistTrackTile extends StatelessWidget {
  final String title;
  final String artist;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const PlaylistTrackTile({
    super.key,
    required this.title,
    required this.artist,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          Icons.music_note,
          color: Colors.purple,
        ),
      ),
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            )
          : null,
      onTap: onTap,
    );
  }
}

