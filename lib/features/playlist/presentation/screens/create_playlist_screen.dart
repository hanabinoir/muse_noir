import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';
import 'package:muse_noir/features/playlist/state/playlist_state.dart';

/// Screen for creating a new playlist
class CreatePlaylistScreen extends ConsumerWidget {
  const CreatePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final uiState = ref.watch(playlistUIStateProvider);

    return BaseScaffold(
      title: 'Create Playlist',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Playlist Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter playlist name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              enabled: !uiState.isLoading,
            ),
            const SizedBox(height: 24),
            Text(
              'Description (Optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter playlist description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
              enabled: !uiState.isLoading,
            ),
            const SizedBox(height: 32),
            if (uiState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    uiState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: uiState.isLoading
                    ? null
                    : () async {
                        final name = nameController.text.trim();
                        final description = descriptionController.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a playlist name'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        try {
                          ref
                              .read(playlistUIStateProvider.notifier)
                              .setLoading(true);

                          await ref
                              .read(playlistsProvider.notifier)
                              .createPlaylist(
                                name,
                                description:
                                    description.isEmpty ? null : description,
                              );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Playlist "$name" created'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ref
                              .read(playlistUIStateProvider.notifier)
                              .setError(e.toString());
                        } finally {
                          ref
                              .read(playlistUIStateProvider.notifier)
                              .setLoading(false);
                        }
                      },
                child: uiState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Playlist'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

