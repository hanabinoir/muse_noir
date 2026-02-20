import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/library/presentation/widgets/track_tile.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Screen for searching tracks across library
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    // final searchText = ref.watch(searchQueryProvider);

    return BaseScaffold(
      title: 'Search',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tracks, artists, albums...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                // suffixIcon: searchText.isNotEmpty
                //     ? IconButton(
                //         icon: const Icon(Icons.clear),
                //         onPressed: () {
                //           ref.read(searchQueryProvider.notifier).state = '';
                //           ref.read(searchResultsProvider.notifier).clearSearch();
                //         },
                //       )
                //     : null,
              ),
              onChanged: (value) {
                // ref.read(searchQueryProvider.notifier).state = value;
                ref.read(searchResultsProvider.notifier).searchTracks(value);
              },
            ),
          ),
          Expanded(
            child: results.isEmpty // && searchText.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for tracks',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              size: 80,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final track = results[index];
                          return TrackTile(
                            title: track.title,
                            artist: track.artist,
                            album: track.album,
                            onTap: () {
                              // Play track
                            },
                            onLongPress: () {
                              // Show options
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

