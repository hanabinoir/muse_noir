import 'package:flutter/material.dart';

/// Player control buttons widget
class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canPlayPrevious;
  final bool canPlayNext;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    this.canPlayPrevious = true,
    this.canPlayNext = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 32,
          onPressed: canPlayPrevious ? onPrevious : null,
        ),
        const SizedBox(width: 24),
        // Play/Pause button
        Container(
          decoration: BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 32,
            ),
            iconSize: 40,
            onPressed: onPlayPause,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 24),
        // Next button
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 32,
          onPressed: canPlayNext ? onNext : null,
        ),
      ],
    );
  }
}

