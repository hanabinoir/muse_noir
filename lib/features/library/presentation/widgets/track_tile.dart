import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// Track tile widget for list display
class TrackTile extends StatelessWidget {
  final int trackId;
  final String title;
  final String artist;
  final String? album;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TrackTile({
    super.key,
    required this.trackId,
    required this.title,
    required this.artist,
    this.album,
    required this.onTap,
    this.onLongPress,
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
        '$artist${album != null ? ' • $album' : ''}',
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
        child: QueryArtworkWidget(
          id: trackId,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Icon(
            Icons.music_note,
            color: Colors.purple,
          ),
          artworkBorder: BorderRadius.circular(4),
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

