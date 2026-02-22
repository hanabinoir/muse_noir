import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/player/state/audio_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';

/// Main player screen showing now playing track with controls
class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackProvider);
    final audioService = ref.watch(audioServiceProvider);

    return BaseScaffold(
      title: 'Now Playing',
      body: currentTrack != null
          ? _buildPlayerContent(context, ref, currentTrack, audioService)
          : _buildEmptyState(),
    );
  }

  Widget _buildPlayerContent(
    BuildContext context,
    WidgetRef ref,
    track,
    dynamic audioService,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album art using QueryArtworkWidget - pass track ID
          _buildArtworkContainer(track.id),
          const SizedBox(height: 32),

          // Track info - static, only changes with new track
          _buildTrackInfo(track),
          const SizedBox(height: 32),

          // Progress bar with StreamBuilder - only rebuilds on position changes
          _buildProgressBarWithStream(ref, audioService),

          const SizedBox(height: 32),

          // Control buttons with real-time play/pause state
          StreamBuilder<PlayerState>(
            stream: audioService.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              return _buildControlButtons(context, ref, isPlaying);
            },
          ),
        ],
      ),
    );
  }

  /// Build track information - updates when track changes
  Widget _buildTrackInfo(dynamic currentTrack) {
    return Column(
      children: [
        Text(
          currentTrack?.title ?? 'Unknown Track',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          currentTrack?.artist ?? 'Unknown Artist',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          currentTrack?.album ?? 'Unknown Album',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build progress bar with StreamBuilder to only rebuild on position/duration changes
  Widget _buildProgressBarWithStream(WidgetRef ref, dynamic audioService) {
    return StreamBuilder<Duration>(
      stream: audioService.positionStream,
      builder: (context, positionSnapshot) {
        return StreamBuilder<Duration?>(
          stream: audioService.durationStream,
          builder: (context, durationSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final trackDuration = durationSnapshot.data ?? Duration.zero;

            return _buildProgressBar(ref, position, trackDuration);
          },
        );
      },
    );
  }

  /// Build artwork container using QueryArtworkWidget
  Widget _buildArtworkContainer(int trackId) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: QueryArtworkWidget(
        id: trackId,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(
          Icons.music_note,
          size: 150,
          color: Colors.purple,
        ),
        artworkBorder: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildProgressBar(WidgetRef ref, Duration position, Duration duration) {
    final playerController = ref.read(playerControllerProvider);

    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble(),
          onChanged: (value) {
            playerController.seek(Duration(milliseconds: value.toInt()));
          },
          activeColor: Colors.purple,
          inactiveColor: Colors.grey[700],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons(BuildContext context, WidgetRef ref, bool isPlaying) {
    final playerController = ref.read(playerControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 32,
          onPressed: () async {
            await playerController.previous();
          },
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
            onPressed: () async {
              await playerController.togglePlayPause();
            },
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 24),

        // Next button
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 32,
          onPressed: () async {
            await playerController.next();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'No track playing',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    }
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  static IconData _getLoopIcon(String loopMode) {
    if (loopMode.contains('one')) {
      return Icons.repeat_one;
    } else if (loopMode.contains('all')) {
      return Icons.repeat;
    }
    return Icons.repeat;
  }
}
