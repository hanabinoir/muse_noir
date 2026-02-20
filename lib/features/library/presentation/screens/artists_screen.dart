import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/artist_card.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen displaying all available artists
class ArtistsScreen extends ConsumerWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistsProvider);

    // Auto-load artists when screen first appears
    ref.listen(artistsProvider, (previous, next) {});

    Future.microtask(() {
      final notifier = ref.read(artistsProvider.notifier);
      if (artists.isEmpty) {
        notifier.fetchAllArtists();
      }
    });

    return BaseScaffold(
      title: 'Artists (${artists.length})',
      body: artists.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No artists found',
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
                final notifier = ref.read(artistsProvider.notifier);
                await notifier.fetchAllArtists();
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];
                  return ArtistCard(
                    name: artist.name,
                    trackCount: artist.numberOfTracks,
                    albumCount: artist.numberOfAlbums,
                    onTap: () {
                      // Navigate to artist details
                    },
                  );
                },
              ),
            ),
    );
  }
}

