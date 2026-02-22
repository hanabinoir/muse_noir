import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_noir/features/player/presentation/widgets/mini_player.dart';
import 'package:muse_noir/features/library/presentation/screens/tracks_screen.dart';
import 'package:muse_noir/features/library/presentation/screens/albums_screen.dart';
import 'package:muse_noir/features/library/presentation/screens/artists_screen.dart';
// import 'package:muse_noir/features/library/presentation/screens/search_screen.dart';
import 'package:muse_noir/features/playlist/presentation/screens/playlists_screen.dart';
import 'package:muse_noir/features/settings/presentation/screens/settings_screen.dart';
import 'package:muse_noir/features/player/presentation/screens/player_screen.dart';

/// Main home screen with navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muse Noir'),
        centerTitle: true,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            // Handle tab changes
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.music_note),
              text: 'Tracks',
            ),
            Tab(
              icon: Icon(Icons.album),
              text: 'Albums',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'Artists',
            ),
            Tab(
              icon: Icon(Icons.playlist_play),
              text: 'Playlists',
            ),
            // Tab(
            //   icon: Icon(Icons.search),
            //   text: 'Search',
            // ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [
              TracksScreen(),
              AlbumsScreen(),
              ArtistsScreen(),
              PlaylistsScreen(),
              // SearchScreen(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlayerScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
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


