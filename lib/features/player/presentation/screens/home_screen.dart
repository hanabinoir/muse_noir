import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';
import 'package:muse_noir/features/library/presentation/screens/tracks_screen.dart';
import 'package:muse_noir/features/library/presentation/screens/albums_screen.dart';
import 'package:muse_noir/features/library/presentation/screens/artists_screen.dart';
import 'package:muse_noir/features/playlist/presentation/screens/playlists_screen.dart';
import 'package:muse_noir/features/settings/presentation/screens/settings_screen.dart';
import 'package:muse_noir/features/player/presentation/screens/player_screen.dart';

/// Tab configuration constants
class TabConfig {
  static const List<TabItem> tabs = [
    TabItem(
      label: 'Tracks',
      icon: Icons.music_note,
    ),
    TabItem(
      label: 'Albums',
      icon: Icons.album,
    ),
    TabItem(
      label: 'Artists',
      icon: Icons.person,
    ),
    TabItem(
      label: 'Playlists',
      icon: Icons.playlist_play,
    ),
  ];

  static const List<Widget> screens = [
    TracksScreen(),
    AlbumsScreen(),
    ArtistsScreen(),
    PlaylistsScreen(),
  ];
}

/// Tab item configuration
class TabItem {
  final String label;
  final IconData icon;

  const TabItem({
    required this.label,
    required this.icon,
  });
}

/// Main home screen with bottom navigation and tab content
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muse Noir'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: TabConfig.screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Global MiniPlayer - displayed above tabs when playing
          const MiniPlayer(),
          // Bottom navigation tabs
          BottomNavigationBar(
            currentIndex: _currentTabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            items: TabConfig.tabs
                .map((tab) => BottomNavigationBarItem(
                      icon: Icon(tab.icon),
                      label: tab.label,
                    ))
                .toList(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Muse Noir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Music Player',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.play_circle),
              title: const Text('Now Playing'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlayerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Muse Noir',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'A beautiful music player for local audio files',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}





