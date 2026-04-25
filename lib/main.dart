import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:muse_noir/core/theme/app_theme.dart';
import 'package:muse_noir/core/utils/logger.dart';
import 'package:muse_noir/data/datasources/hive_adapters/playlist_adapter.dart';
import 'package:muse_noir/features/permissions/presentation/app_root.dart';
import 'package:muse_noir/features/player/presentation/screens/home_screen.dart';

final AppLogger _logger = AppLogger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(PlaylistAdapter());

    _logger.info('Hive initialized successfully');
  } catch (e, st) {
    _logger.error('Error initializing Hive', error: e, stackTrace: st);
  }

  try {
    // Initialize MediaKit for audio playback
    MediaKit.ensureInitialized();
    _logger.info('MediaKit initialized successfully');
  } catch (e, st) {
    _logger.error('Failed to initialize MediaKit', error: e, stackTrace: st);
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Muse Noir',
      theme: AppTheme.darkTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: const AppRoot(
        mainAppWidget: HomeScreen(),
      ),
    );
  }
}

