import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
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
    final position = ref.watch(positionProvider);
    final duration = ref.watch(durationProvider);
    final audioService = ref.watch(audioServiceProvider);

    return BaseScaffold(
      title: 'Now Playing',
      body: currentTrack != null
          ? _buildPlayerContent(context, ref, currentTrack, audioService, position, duration)
          : _buildEmptyState(),
    );
  }

  Widget _buildPlayerContent(
    BuildContext context,
    WidgetRef ref,
    dynamic track,
    dynamic audioService,
    AsyncValue<Duration> position,
    AsyncValue<Duration?> duration,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album art placeholder
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.music_note,
              size: 150,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 32),

          // Track info
          Text(
            track.title ?? 'Unknown Track',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            track.artist ?? 'Unknown Artist',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            track.album ?? 'Unknown Album',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Progress bar
          position.when(
            data: (pos) => duration.when(
              data: (dur) => _buildProgressBar(ref, pos, dur ?? Duration.zero),
              loading: () => const SizedBox(height: 80),
              error: (_, __) => const SizedBox(height: 80),
            ),
            loading: () => const SizedBox(height: 80),
            error: (_, __) => const SizedBox(height: 80),
          ),

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
