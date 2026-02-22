import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/album.dart';
import 'package:muse_noir/domain/entities/artist.dart';
import 'package:muse_noir/features/playlist/state/selected_tracks_state.dart';
import 'package:muse_noir/features/playlist/state/playlist_state.dart';
import 'package:muse_noir/features/playlist/presentation/widgets/selectable_track_tile.dart';
import 'package:muse_noir/features/library/state/library_state.dart';

/// Bottom sheet for selecting tracks to add to a playlist
class AddTracksBottomSheet extends ConsumerStatefulWidget {
  final String playlistId;
  final List<int> existingTrackIds;
  final VoidCallback onTracksAdded;

  const AddTracksBottomSheet({
    super.key,
    required this.playlistId,
    required this.existingTrackIds,
    required this.onTracksAdded,
  });

  @override
  ConsumerState<AddTracksBottomSheet> createState() =>
      _AddTracksBottomSheetState();
}

class _AddTracksBottomSheetState extends ConsumerState<AddTracksBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Track> _filteredTracks = [];
  List<Album> _filteredAlbums = [];
  List<Artist> _filteredArtists = [];
  bool _isLoading = false;
  String _error = '';
  final Map<String, bool> _expandedAlbums = {};
  final Map<String, bool> _expandedArtists = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _filterData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final allTracks = ref.read(tracksProvider);
      final allAlbums = ref.read(albumsProvider);
      final allArtists = ref.read(artistsProvider);

      if (allTracks.isEmpty) {
        await ref.read(tracksProvider.notifier).fetchAllTracks();
      }
      if (allAlbums.isEmpty) {
        await ref.read(albumsProvider.notifier).fetchAllAlbums();
      }
      if (allArtists.isEmpty) {
        await ref.read(artistsProvider.notifier).fetchAllArtists();
      }

      setState(() {
        _isLoading = false;
        _filterData();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading data: $e';
      });
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    final allTracks = ref.read(tracksProvider);
    final allAlbums = ref.read(albumsProvider);
    final allArtists = ref.read(artistsProvider);

    _filteredTracks = allTracks
        .where((track) =>
            !widget.existingTrackIds.contains(track.id) &&
            (query.isEmpty ||
                track.title.toLowerCase().contains(query) ||
                track.artist.toLowerCase().contains(query)))
        .toList();

    _filteredAlbums = allAlbums
        .where((album) =>
            query.isEmpty || album.title.toLowerCase().contains(query))
        .toList();

    _filteredArtists = allArtists
        .where((artist) =>
            query.isEmpty || artist.name.toLowerCase().contains(query))
        .toList();
  }

  bool _isTrackDisabled(int trackId) {
    return widget.existingTrackIds.contains(trackId);
  }

  Future<void> _addSelectedTracks() async {
    final selectedTracks = ref.read(selectedTracksProvider).toList();
    if (selectedTracks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one track')),
      );
      return;
    }

    // Show loading dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.purple),
                ),
                const SizedBox(height: 16),
                Text(
                  'Adding ${selectedTracks.length} track(s)...',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    try {
      final playlistsNotifier = ref.read(playlistsProvider.notifier);
      int successCount = 0;

      for (final trackId in selectedTracks) {
        try {
          await playlistsNotifier.addTrackToPlaylist(
            widget.playlistId,
            trackId,
          );
          successCount++;
        } catch (e) {
          // Continue with next track even if one fails
        }
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pop(); // Close bottom sheet

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully added $successCount track(s)'),
            backgroundColor: Colors.green[700],
          ),
        );

        // Clear selections
        ref.read(selectedTracksProvider.notifier).clearSelection();
        widget.onTracksAdded();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding tracks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTracks = ref.watch(selectedTracksProvider);
    final totalTracks = ref.watch(tracksProvider).length;
    final shouldShowTabs = totalTracks > 100;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Tracks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Search field
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search tracks, albums, artists...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(_filterData);
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.purple, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      onChanged: (_) {
                        setState(_filterData);
                      },
                    ),
                  ],
                ),
              ),
              // Tab bar (only show if > 100 tracks)
              if (shouldShowTabs)
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.purple,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[500],
                  tabs: const [
                    Tab(text: 'All Tracks'),
                    Tab(text: 'Albums'),
                    Tab(text: 'Artists'),
                  ],
                ),
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.purple),
                        ),
                      )
                    : _error.isNotEmpty
                        ? Center(
                            child: Text(
                              _error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : shouldShowTabs
                            ? TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildAllTracksTab(scrollController),
                                  _buildAlbumsTab(scrollController),
                                  _buildArtistsTab(scrollController),
                                ],
                              )
                            : _buildAllTracksTab(scrollController),
              ),
              // Footer with selection count and action buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (selectedTracks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '${selectedTracks.length} track(s) selected',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedTracks.isEmpty
                                ? null
                                : _addSelectedTracks,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              disabledBackgroundColor: Colors.grey[700],
                            ),
                            child: Text(
                              'Add (${selectedTracks.length})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllTracksTab(ScrollController scrollController) {
    if (_filteredTracks.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'No tracks match your search'
              : 'All available tracks already in playlist',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: _filteredTracks.length,
      itemBuilder: (context, index) {
        final track = _filteredTracks[index];
        final isSelected = ref.watch(selectedTracksProvider).contains(track.id);

        return SelectableTrackTile(
          trackId: track.id,
          title: track.title,
          artist: track.artist,
          album: track.album,
          isSelected: isSelected,
          isDisabled: _isTrackDisabled(track.id),
          disabledReason: 'Already in playlist',
          onChanged: (_) {
            ref.read(selectedTracksProvider.notifier).toggleTrack(track.id);
          },
        );
      },
    );
  }

  Widget _buildAlbumsTab(ScrollController scrollController) {
    if (_filteredAlbums.isEmpty) {
      return Center(
        child: Text(
          'No albums found',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    final allTracks = ref.watch(tracksProvider);

    return ListView.builder(
      controller: scrollController,
      itemCount: _filteredAlbums.length,
      itemBuilder: (context, index) {
        final album = _filteredAlbums[index];
        final isExpanded = _expandedAlbums[album.id.toString()] ?? false;

        // Get tracks that belong to this album
        final albumTracks = allTracks
            .where((t) => album.trackIds.contains(t.id))
            .toList();

        // Filter out tracks already in playlist
        final availableTracks = albumTracks
            .where((t) => !widget.existingTrackIds.contains(t.id))
            .toList();

        return Column(
          children: [
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.album,
                  color: Colors.purple,
                ),
              ),
              title: Text(
                album.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${availableTracks.length}/${albumTracks.length} tracks',
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: Colors.grey[400],
              ),
              onTap: () {
                setState(() {
                  _expandedAlbums[album.id.toString()] = !isExpanded;
                });
              },
            ),
            if (isExpanded)
              ...availableTracks.asMap().entries.map((entry) {
                final track = entry.value;
                final isSelected =
                    ref.watch(selectedTracksProvider).contains(track.id);

                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SelectableTrackTile(
                    trackId: track.id,
                    title: track.title,
                    artist: track.artist,
                    album: track.album,
                    isSelected: isSelected,
                    isDisabled: _isTrackDisabled(track.id),
                    onChanged: (_) {
                      ref
                          .read(selectedTracksProvider.notifier)
                          .toggleTrack(track.id);
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildArtistsTab(ScrollController scrollController) {
    if (_filteredArtists.isEmpty) {
      return Center(
        child: Text(
          'No artists found',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    final allTracks = ref.watch(tracksProvider);

    return ListView.builder(
      controller: scrollController,
      itemCount: _filteredArtists.length,
      itemBuilder: (context, index) {
        final artist = _filteredArtists[index];
        final isExpanded = _expandedArtists[artist.id.toString()] ?? false;

        // Get tracks that belong to this artist
        final artistTracks = allTracks
            .where((t) => artist.trackIds.contains(t.id))
            .toList();

        // Filter out tracks already in playlist
        final availableTracks = artistTracks
            .where((t) => !widget.existingTrackIds.contains(t.id))
            .toList();

        return Column(
          children: [
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
              ),
              title: Text(
                artist.name,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${availableTracks.length}/${artistTracks.length} tracks',
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: Colors.grey[400],
              ),
              onTap: () {
                setState(() {
                  _expandedArtists[artist.id.toString()] = !isExpanded;
                });
              },
            ),
            if (isExpanded)
              ...availableTracks.asMap().entries.map((entry) {
                final track = entry.value;
                final isSelected =
                    ref.watch(selectedTracksProvider).contains(track.id);

                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SelectableTrackTile(
                    trackId: track.id,
                    title: track.title,
                    artist: track.artist,
                    album: track.album,
                    isSelected: isSelected,
                    isDisabled: _isTrackDisabled(track.id),
                    onChanged: (_) {
                      ref
                          .read(selectedTracksProvider.notifier)
                          .toggleTrack(track.id);
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}











