import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/artist_card.dart';
import 'package:muse_noir/features/library/presentation/screens/artist_tracks_screen.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen displaying all available artists
class ArtistsScreen extends ConsumerWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistsProvider);

    return BaseScaffold(
      title: 'Artists (${artists.length})',
      body: RefreshIndicator(
        onRefresh: () async {
          final notifier = ref.read(artistsProvider.notifier);
          await notifier.fetchAllArtists();
        },
        child: artists.isEmpty
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
                          const SizedBox(height: 8),
                          Text(
                            'Pull down to load artists',
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
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];

                  return ArtistCard(
                    artistId: artist.id,
                    name: artist.name,
                    trackCount: artist.numberOfTracks,
                    albumCount: artist.numberOfAlbums,
                    onTap: () async {
                      // Fetch and display tracks for this artist, categorized by album
                      final artistTracksNotifier =
                          ref.read(artistTracksProvider.notifier);
                      await artistTracksNotifier.fetchTracksForArtist(
                        artist.id.toString(),
                      );

                      // Navigate to artist tracks screen
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistTracksScreen(
                              artistName: artist.name,
                              artistId: artist.id.toString(),
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

