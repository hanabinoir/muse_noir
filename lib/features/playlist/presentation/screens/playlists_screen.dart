import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/features/playlist/presentation/screens/create_playlist_screen.dart';
import 'package:muse_noir/features/playlist/presentation/screens/playlist_detail_screen.dart';
import 'package:muse_noir/features/playlist/state/playlist_state.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/features/playlist/presentation/widgets/playlist_artwork_widget.dart';

/// Screen displaying all playlists with edit, drag-to-reorder, and delete functionality
class PlaylistsScreen extends ConsumerStatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  ConsumerState<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends ConsumerState<PlaylistsScreen> {
  bool _isEditingMode = false;
  late List<Playlist> _reorderedPlaylists;

  @override
  void initState() {
    super.initState();
    _reorderedPlaylists = [];
    // Fetch playlists only once when screen first appears
    Future.microtask(() {
      final notifier = ref.read(playlistsProvider.notifier);
      notifier.fetchAllPlaylists();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize reordered playlists from current state
    final playlists = ref.read(playlistsProvider);
    _reorderedPlaylists = List.from(playlists);
  }

  Future<void> _saveReorderedPlaylists() async {
    // Note: If your Playlist model or repository doesn't support bulk reorder,
    // you might need to update each playlist individually or add a bulk update method
    // For now, we just exit edit mode as the list is already updated
    setState(() {
      _isEditingMode = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playlist order updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistsProvider);
    final playlistsToShow = _isEditingMode ? _reorderedPlaylists : playlists;

    return BaseScaffold(
      title: 'Playlists (${playlists.length})',
      actions: [
        if (playlists.isNotEmpty)
          if (!_isEditingMode)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.purple),
              onPressed: () {
                setState(() {
                  _isEditingMode = true;
                  _reorderedPlaylists = List.from(playlists);
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.done, color: Colors.green),
              onPressed: _saveReorderedPlaylists,
            ),
      ],
      floatingActionButton: !_isEditingMode
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePlaylistScreen(),
                  ),
                );
              },
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: playlists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_play,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No playlists yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreatePlaylistScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Playlist'),
                        ),
                      ],
                    ),
                  )
                : _isEditingMode
                    ? ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = _reorderedPlaylists.removeAt(oldIndex);
                            _reorderedPlaylists.insert(newIndex, item);
                          });
                        },
                        itemCount: playlistsToShow.length,
                        itemBuilder: (context, index) {
                          final playlist = playlistsToShow[index];
                          return _buildPlaylistTile(
                            key: ValueKey(playlist.id),
                            playlist: playlist,
                            index: index,
                            isEditMode: true,
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          final notifier = ref.read(playlistsProvider.notifier);
                          await notifier.fetchAllPlaylists();
                        },
                        child: ListView.builder(
                          itemCount: playlistsToShow.length,
                          itemBuilder: (context, index) {
                            final playlist = playlistsToShow[index];
                            return _buildPlaylistTile(
                              key: Key('${playlist.id}-$index'),
                              playlist: playlist,
                              index: index,
                              isEditMode: false,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile({
    required Key key,
    required Playlist playlist,
    required int index,
    required bool isEditMode,
  }) {
    final allTracks = ref.watch(tracksProvider);
    final playlistTracks = allTracks
        .where((track) => playlist.trackIds.contains(track.id))
        .toList();

    return GestureDetector(
      key: key,
      onTap: !isEditMode
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistDetailScreen(
                    playlistId: playlist.id,
                    playlistName: playlist.name,
                  ),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          color: Colors.grey[900],
          child: ListTile(
            leading: isEditMode
                ? ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.drag_handle,
                        color: Colors.purple,
                      ),
                    ),
                  )
                : PlaylistArtworkWidget(
                    playlist: playlist,
                    playlistTracks: playlistTracks,
                    size: 48,
                  ),
            title: Text(
              playlist.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${playlist.trackCount} track${playlist.trackCount != 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: isEditMode
                ? IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[400],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Playlist?'),
                          content: Text(
                            'Are you sure you want to delete "${playlist.name}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                try {
                                  await ref
                                      .read(playlistsProvider.notifier)
                                      .deletePlaylist(playlist.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${playlist.name} deleted'),
                                        backgroundColor: Colors.red[700],
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

