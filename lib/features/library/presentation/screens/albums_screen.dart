import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/album_card.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen displaying all available albums
class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);

    // Auto-load albums when screen first appears
    ref.listen(albumsProvider, (previous, next) {});

    Future.microtask(() {
      final notifier = ref.read(albumsProvider.notifier);
      if (albums.isEmpty) {
        notifier.fetchAllAlbums();
      }
    });

    return BaseScaffold(
      title: 'Albums (${albums.length})',
      body: albums.isEmpty
          ? Center(
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
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                final notifier = ref.read(albumsProvider.notifier);
                await notifier.fetchAllAlbums();
              },
              child: GridView.builder(
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
                    title: album.title,
                    artist: album.artist,
                    trackCount: album.trackIds.length,
                    onTap: () {
                      // Navigate to album details
                    },
                  );
                },
              ),
            ),
    );
  }
}

