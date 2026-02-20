import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/core/widgets/base_scaffold.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      title: 'Settings',
      body: ListView(
        children: [
          // Theme section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            subtitle: const Text('Currently enabled'),
            trailing: const Icon(Icons.dark_mode),
            onTap: () {
              // Toggle theme
            },
          ),
          const Divider(),
          // About section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            trailing: const Icon(Icons.info),
          ),
          ListTile(
            title: const Text('About Muse Noir'),
            subtitle: const Text('A beautiful music player'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // Show about dialog
            },
          ),
        ],
      ),
    );
  }
}

