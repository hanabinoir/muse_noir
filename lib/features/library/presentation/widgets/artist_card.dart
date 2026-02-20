import 'package:flutter/material.dart';

/// Artist card widget for list display
class ArtistCard extends StatelessWidget {
  final String name;
  final int trackCount;
  final int albumCount;
  final VoidCallback onTap;

  const ArtistCard({
    super.key,
    required this.name,
    required this.trackCount,
    required this.albumCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '$albumCount albums • $trackCount tracks',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

