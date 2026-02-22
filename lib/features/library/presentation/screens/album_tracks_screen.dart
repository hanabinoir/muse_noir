import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen displaying tracks for a selected album
class AlbumTracksScreen extends ConsumerWidget {
  final String albumTitle;
  final String albumId;
  final int albumIntId;

  const AlbumTracksScreen({
    super.key,
    required this.albumTitle,
    required this.albumId,
    required this.albumIntId,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumTracks = ref.watch(albumTracksProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: albumTracks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      // ...existing code...
                    ],
                  ),
          ),
          // MiniPlayer displayed at bottom
          const MiniPlayer(),
        ],
      ),
    );
  }
}

