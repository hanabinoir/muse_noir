import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/album_card.dart';
import 'package:muse_noir/features/library/presentation/screens/album_tracks_screen.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen displaying all available albums
class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);

    return BaseScaffold(
      title: 'Albums (${albums.length})',
      body: RefreshIndicator(
        onRefresh: () async {
          final notifier = ref.read(albumsProvider.notifier);
          await notifier.fetchAllAlbums();
        },
        child: albums.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.album,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No albums found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pull down to load albums',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  return AlbumCard(
                    albumId: album.id,
                    title: album.title,
                    artist: album.artist,
                    trackCount: album.numOfSongs,
                    onTap: () async {
                      // Fetch and display tracks for this album
                      final albumTracksNotifier =
                          ref.read(albumTracksProvider.notifier);
                      await albumTracksNotifier.fetchTracksForAlbum(
                        album.id.toString(),
                      );

                      // Navigate to album tracks screen
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumTracksScreen(
                              albumTitle: album.title,
                              albumId: album.id.toString(),
                              albumIntId: album.id,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

