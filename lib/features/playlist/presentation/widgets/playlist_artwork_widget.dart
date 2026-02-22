import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/domain/entities/track.dart';

/// Smart artwork widget for playlists that displays:
/// - First artwork if < 4 unique albums
/// - First 4 artwork in grid if >= 4 unique albums
/// - Default icon if no tracks
class PlaylistArtworkWidget extends StatelessWidget {
  final Playlist playlist;
  final List<Track> playlistTracks;
  final double size;

  const PlaylistArtworkWidget({
    super.key,
    required this.playlist,
    required this.playlistTracks,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (playlistTracks.isEmpty) {
      return _buildDefaultArtwork();
    }

    // Get unique albums from tracks
    final uniqueAlbums = <String>{};
    final tracksForArtwork = <Track>[];

    for (final track in playlistTracks) {
      if (uniqueAlbums.add(track.albumId ?? track.album)) {
        tracksForArtwork.add(track);
        if (tracksForArtwork.length >= 4) break;
      }
    }

    // If less than 4 unique albums, show first artwork
    if (tracksForArtwork.length < 4) {
      return _buildSingleArtwork(playlistTracks[0]);
    }

    // If 4 or more, show 2x2 grid
    return _buildGridArtwork(tracksForArtwork.take(4).toList());
  }

  Widget _buildDefaultArtwork() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.playlist_play,
        color: Colors.purple,
      ),
    );
  }

  Widget _buildSingleArtwork(Track track) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: QueryArtworkWidget(
        id: track.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(
          Icons.music_note,
          color: Colors.purple,
        ),
        artworkBorder: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildGridArtwork(List<Track> tracks) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: List.generate(
          4,
          (index) {
            final track = tracks[index];
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: index == 0 || index == 1
                    ? Radius.circular(index == 0 ? 8 : 0)
                    : Radius.zero,
                topRight: index == 0 || index == 1
                    ? Radius.circular(index == 1 ? 8 : 0)
                    : Radius.zero,
                bottomLeft: index == 2 || index == 3
                    ? Radius.circular(index == 2 ? 8 : 0)
                    : Radius.zero,
                bottomRight: index == 2 || index == 3
                    ? Radius.circular(index == 3 ? 8 : 0)
                    : Radius.zero,
              ),
              child: QueryArtworkWidget(
                id: track.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  color: Colors.purple.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.purple,
                    size: 16,
                  ),
                ),
                artworkBorder: BorderRadius.zero,
              ),
            );
          },
        ),
      ),
    );
  }
}

