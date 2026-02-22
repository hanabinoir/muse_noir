import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muse_noir/features/player/state/audio_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';
import 'package:muse_noir/features/player/presentation/screens/player_screen.dart';

/// Compact mini player widget shown at bottom of main screens
class MiniPlayer extends ConsumerWidget {
  final VoidCallback? onTap;

  const MiniPlayer({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackProvider);
    final audioService = ref.watch(audioServiceProvider);

    return currentTrack != null
        ? GestureDetector(
            onTap: onTap ?? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PlayerScreen(),
                ),
              );
            },
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  // Artwork container using QueryArtworkWidget
                  _buildArtworkContainer(currentTrack.id),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTrack.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentTrack.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Only play/pause button rebuilds on playback state changes
                  StreamBuilder<PlayerState>(
                    stream: audioService.playerStateStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data?.playing ?? false;
                      return IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          size: 32,
                          color: Colors.purple,
                        ),
                        onPressed: () async {
                          final playerController =
                              ref.read(playerControllerProvider);
                          await playerController.togglePlayPause();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  /// Build artwork container using QueryArtworkWidget
  Widget _buildArtworkContainer(int trackId) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: QueryArtworkWidget(
        id: trackId,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(
          Icons.music_note,
          color: Colors.purple,
        ),
        artworkBorder: BorderRadius.circular(6),
      ),
    );
  }
}



