import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/track_tile.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';

/// Screen displaying tracks for a selected artist, categorized by album
class ArtistTracksScreen extends ConsumerWidget {
  final String artistName;
  final String artistId;

  const ArtistTracksScreen({
    super.key,
    required this.artistName,
    required this.artistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistTracks = ref.watch(artistTracksProvider);

    // Group tracks by album
    final tracksByAlbum = <String, List<dynamic>>{};
    for (final track in artistTracks) {
      final albumKey = track.album;
      if (!tracksByAlbum.containsKey(albumKey)) {
        tracksByAlbum[albumKey] = [];
      }
      tracksByAlbum[albumKey]!.add(track);
    }

    return BaseScaffold(
      title: 'Tracks from $artistName',
      body: Column(
        children: [
          Expanded(
            child: artistTracks.isEmpty
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
                : ListView.builder(
                    itemCount: tracksByAlbum.length,
                    itemBuilder: (context, index) {
                      final albumName = tracksByAlbum.keys.elementAt(index);
                      final tracks = tracksByAlbum[albumName]!;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              albumName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...tracks.asMap().entries.map((entry) {
                            final track = entry.value;

                            // Calculate the global index of this track in artistTracks
                            final globalIndex = artistTracks.indexOf(track);

                            return TrackTile(
                              trackId: track.id,
                              title: track.title,
                              artist: track.artist,
                              album: track.album,
                              onTap: () async {
                                // Play artist tracks as playlist starting from this track
                                final playerController =
                                    ref.read(playerControllerProvider);
                                await playerController.playPlaylist(
                                  artistTracks,
                                  startIndex: globalIndex,
                                );
                              },
                              onLongPress: () {
                                // Show track info
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${track.title} - ${track.artist}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
          // MiniPlayer displayed at bottom
          const MiniPlayer(),
        ],
      ),
    );
  }
}

