import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/domain/entities/track.dart';
import 'package:muse_noir/domain/entities/playlist.dart';
import 'package:muse_noir/features/playlist/state/playlist_state.dart';
import 'package:muse_noir/features/playlist/presentation/screens/add_tracks_bottom_sheet.dart';
import 'package:muse_noir/features/library/state/library_state.dart';
import 'package:muse_noir/features/player/controller/player_controller.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';

/// Screen showing details of a specific playlist with edit, drag-to-reorder, and delete functionality
class PlaylistDetailScreen extends ConsumerStatefulWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  ConsumerState<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  bool _isEditingMode = false;
  late List<int> _reorderedTrackIds;

  @override
  void initState() {
    super.initState();
    _reorderedTrackIds = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize reordered track IDs from current playlist
    final playlists = ref.read(playlistsProvider);
    final playlist = playlists.firstWhere(
      (p) => p.id == widget.playlistId,
      orElse: () => null as dynamic,
    ) as Playlist?;
    if (playlist != null) {
      _reorderedTrackIds = List.from(playlist.trackIds);
    }
  }

  Future<void> _saveReorderedPlaylist() async {
    try {
      final playlists = ref.read(playlistsProvider);
      final playlist = playlists.firstWhere(
        (p) => p.id == widget.playlistId,
      );

      final updatedPlaylist = playlist.copyWith(trackIds: _reorderedTrackIds);
      await ref.read(playlistsProvider.notifier).updatePlaylist(updatedPlaylist);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Playlist order updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        _isEditingMode = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistsProvider);
    final allTracks = ref.watch(tracksProvider);

    final playlist = playlists.firstWhere(
      (p) => p.id == widget.playlistId,
      orElse: () => null as dynamic,
    ) as Playlist?;

    // Get track details for playlist using reordered IDs in edit mode
    final trackIdsToUse = _isEditingMode ? _reorderedTrackIds : (playlist?.trackIds ?? []);
    final playlistTracks = allTracks
        .where((track) => trackIdsToUse.contains(track.id))
        .toList()
      ..sort((a, b) => trackIdsToUse.indexOf(a.id).compareTo(trackIdsToUse.indexOf(b.id)));

    return BaseScaffold(
      title: widget.playlistName,
      actions: [
        if (!_isEditingMode)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.purple),
            onPressed: () {
              setState(() {
                _isEditingMode = true;
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.done, color: Colors.green),
            onPressed: _saveReorderedPlaylist,
          ),
      ],
      floatingActionButton: !_isEditingMode
          ? FloatingActionButton(
              onPressed: () {
                if (playlist != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddTracksBottomSheet(
                      playlistId: widget.playlistId,
                      existingTrackIds: playlist.trackIds,
                      onTracksAdded: () {
                        // Refresh playlists to update UI
                        ref.read(playlistsProvider.notifier).fetchAllPlaylists();
                      },
                    ),
                  );
                }
              },
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: playlist == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Playlist not found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : playlistTracks.isEmpty
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
                              'No tracks in playlist',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => AddTracksBottomSheet(
                                    playlistId: widget.playlistId,
                                    existingTrackIds: playlist.trackIds,
                                    onTracksAdded: () {
                                      ref
                                          .read(
                                              playlistsProvider.notifier)
                                          .fetchAllPlaylists();
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Tracks'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
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
                                final item = _reorderedTrackIds.removeAt(oldIndex);
                                _reorderedTrackIds.insert(newIndex, item);
                              });
                            },
                            itemCount: playlistTracks.length,
                            itemBuilder: (context, index) {
                              final track = playlistTracks[index];
                              return _buildTrackTile(
                                key: ValueKey(track.id),
                                track: track,
                                index: index,
                                isEditMode: true,
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: playlistTracks.length,
                            itemBuilder: (context, index) {
                              final track = playlistTracks[index];
                              return _buildTrackTile(
                                key: Key('${track.id}-$index'),
                                track: track,
                                index: index,
                                isEditMode: false,
                              );
                            },
                          ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildTrackTile({
    required Key key,
    required Track track,
    required int index,
    required bool isEditMode,
  }) {
    return ListTile(
      key: key,
      leading: isEditMode
          ? ReorderableDragStartListener(
              index: index,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.drag_handle,
                  color: Colors.purple,
                ),
              ),
            )
          : Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.purple,
              ),
            ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        '${track.artist}${track.album.isNotEmpty ? ' • ${track.album}' : ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: isEditMode
          ? IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.red[400],
              ),
              onPressed: () {
                setState(() {
                  _reorderedTrackIds.remove(track.id);
                });
              },
            )
          : null,
      onTap: !isEditMode
          ? () async {
              final playerController = ref.read(playerControllerProvider);
              final playlists = ref.read(playlistsProvider);
              final playlist = playlists.firstWhere(
                (p) => p.id == widget.playlistId,
              );
              final allTracks = ref.read(tracksProvider);
              final currentPlaylistTracks = allTracks
                  .where((t) => playlist.trackIds.contains(t.id))
                  .toList()
                ..sort((a, b) => playlist.trackIds.indexOf(a.id).compareTo(playlist.trackIds.indexOf(b.id)));

              await playerController.playPlaylist(
                currentPlaylistTracks,
                startIndex: index,
              );
            }
          : null,
    );
  }
}

