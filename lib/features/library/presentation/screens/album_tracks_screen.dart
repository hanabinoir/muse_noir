import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:muse_noir/features/library/presentation/widgets/album_track_tile.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';

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
                      // Album header with artwork and toolbar
                      SliverAppBar(
                        backgroundColor: Colors.grey[900],
                        expandedHeight: 320,
                        pinned: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Colors.grey[900],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: QueryArtworkWidget(
                                    id: albumIntId,
                                    type: ArtworkType.ALBUM,
                                    nullArtworkWidget: const Icon(
                                      Icons.album,
                                      size: 100,
                                      color: Colors.purple,
                                    ),
                                    artworkBorder: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  albumTitle,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${albumTracks.length} tracks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Tracks list
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final track = albumTracks[index];
                            return AlbumTrackTile(
                              trackNumber: index + 1,
                              title: track.title,
                              artist: track.artist,
                              duration: _formatDuration(track.duration),
                              onTap: () async {
                                // Play album tracks as playlist starting from this track
                                final playerController =
                                ref.read(playerControllerProvider);
                                await playerController.playPlaylist(
                                  albumTracks,
                                  startIndex: index,
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
                          },
                          childCount: albumTracks.length,
                        ),
                      ),
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

