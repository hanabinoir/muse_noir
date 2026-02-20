import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';

/// Screen for creating a new playlist
class CreatePlaylistScreen extends ConsumerWidget {
  const CreatePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      title: 'Create Playlist',
      body: const Center(
        child: Text('Create playlist coming soon...'),
      ),
    );
  }
}

