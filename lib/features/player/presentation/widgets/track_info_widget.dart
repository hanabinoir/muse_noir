import 'package:flutter/material.dart';

/// Track information display widget
class TrackInfoWidget extends StatelessWidget {
  final String title;
  final String artist;
  final String? album;

  const TrackInfoWidget({
    super.key,
    required this.title,
    required this.artist,
    this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (album != null) ...[
          const SizedBox(height: 4),
          Text(
            album!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

