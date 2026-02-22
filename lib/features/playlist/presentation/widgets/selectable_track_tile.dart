import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// Track tile widget with selection checkbox for add-to-playlist dialogs
class SelectableTrackTile extends StatelessWidget {
  final int trackId;
  final String title;
  final String artist;
  final String? album;
  final bool isSelected;
  final bool isDisabled;
  final String? disabledReason;
  final ValueChanged<bool> onChanged;

  const SelectableTrackTile({
    super.key,
    required this.trackId,
    required this.title,
    required this.artist,
    this.album,
    required this.isSelected,
    this.isDisabled = false,
    this.disabledReason,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDisabled ? Colors.grey[600] : Colors.white;
    final subtitleColor = isDisabled ? Colors.grey[700] : Colors.grey[400];

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: ListTile(
        enabled: !isDisabled,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: isDisabled ? 0.1 : 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: QueryArtworkWidget(
            id: trackId,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: Icon(
              Icons.music_note,
              color: isDisabled ? Colors.grey[700] : Colors.purple,
            ),
            artworkBorder: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textColor),
        ),
        subtitle: Text(
          '$artist${album != null ? ' • $album' : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: subtitleColor),
        ),
        trailing: Checkbox(
          value: isSelected && !isDisabled,
          onChanged: isDisabled ? null : (bool? value) {
            if (value != null) {
              onChanged(value);
            }
          },
          activeColor: Colors.purple,
        ),
        onTap: isDisabled
            ? null
            : () {
                onChanged(!isSelected);
              },
        hoverColor: isDisabled ? null : Colors.grey[800],
      ),
    );
  }
}



