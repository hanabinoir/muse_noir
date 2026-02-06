import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/extensions/duration_extension.dart';
import 'package:muse_noir/core/widgets/loading_indicator.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';
import 'package:muse_noir/features/player/state/audio_state.dart';
import 'package:muse_noir/features/player/state/playback_state_enum.dart';

/// Simple player screen widget - basic implementation for Phase 2
class SimplePlayerScreen extends ConsumerWidget {
  const SimplePlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackProvider);
    final playbackState = ref.watch(playbackStateProvider);
    final position = ref.watch(positionProvider);
    final duration = ref.watch(durationProvider);
    final loopMode = ref.watch(loopModeProvider);
    final shuffleMode = ref.watch(shuffleModeProvider);
    final playerController = ref.watch(playerControllerProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Currently Playing Track Info
        if (currentTrack != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  currentTrack.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  currentTrack.artist,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  currentTrack.album,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        else
          Text(
            'No track playing',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        const SizedBox(height: 32),

        // Playback State
        playbackState.when(
          data: (state) {
            return Column(
              children: [
                Text(
                  state.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: state.isPlaying ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingIndicator(),
          error: (error, st) => Text('Error: $error'),
        ),
        const SizedBox(height: 16),

        // Progress Bar
        position.when(
          data: (pos) {
            return duration.when(
              data: (dur) {
                return Column(
                  children: [
                    Slider(
                      value: dur != null && dur.inMilliseconds > 0
                          ? pos.inMilliseconds / dur.inMilliseconds
                          : 0,
                      onChanged: (value) {
                        if (dur != null) {
                          final newPosition = Duration(
                            milliseconds: (value * dur.inMilliseconds).toInt(),
                          );
                          playerController.seek(newPosition);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(pos.toFormattedString()),
                          Text(dur?.toFormattedString() ?? '0:00'),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            );
          },
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
        const SizedBox(height: 32),

        // Control Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () => playerController.previous(),
            ),
            const SizedBox(width: 16),
            // Play/Pause
            playbackState.when(
              data: (state) {
                return IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 48,
                  onPressed: () => playerController.togglePlayPause(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            // Next
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => playerController.next(),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Loop and Shuffle Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shuffle
            IconButton(
              icon: const Icon(Icons.shuffle),
              color: shuffleMode ? Colors.blue : null,
              onPressed: () => playerController.toggleShuffle(),
            ),
            const SizedBox(width: 16),
            // Loop
            IconButton(
              icon: Icon(
                loopMode.name == 'one'
                    ? Icons.repeat_one
                    : Icons.repeat,
              ),
              color: loopMode.name == 'off' ? null : Colors.blue,
              onPressed: () => playerController.toggleLoop(),
            ),
          ],
        ),
      ],
    );
  }
}

