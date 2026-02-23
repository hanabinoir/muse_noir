import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/track_tile.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';

/// Screen displaying all available tracks
class TracksScreen extends ConsumerWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(tracksProvider);

    // Auto-load tracks when screen first appears
    ref.listen(tracksProvider, (previous, next) {});

    Future.microtask(() {
      final notifier = ref.read(tracksProvider.notifier);
      if (tracks.isEmpty) {
        notifier.fetchAllTracks();
      }
    });

    return BaseScaffold(
      title: 'Tracks (${tracks.length})',
      body: tracks.isEmpty
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
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                final notifier = ref.read(tracksProvider.notifier);
                await notifier.fetchAllTracks();
              },
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return TrackTile(
                    trackId: track.id,
                    title: track.title,
                    artist: track.artist,
                    album: track.album,
                    onTap: () async {
                      // Play the selected track
                      final playerController = ref.read(playerControllerProvider);
                      await playerController.playTrack(track);
                    },
                    onLongPress: () {
                      // Show track info
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${track.title} - ${track.artist}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

