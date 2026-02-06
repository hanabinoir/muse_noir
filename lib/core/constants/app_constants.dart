/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App metadata
  static const String appName = 'Muse Noir';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A personal music lab';

  // Directory paths
  static const String musicDirectoryName = 'Music';

  // File extensions
  static const String mp3Extension = '.mp3';
  static const String flacExtension = '.flac';
  static const List<String> supportedAudioFormats = [mp3Extension, flacExtension];

  // Hive box names
  static const String playlistBoxName = 'playlists';
  static const String favoritesBoxName = 'favorites';
  static const String settingsBoxName = 'settings';

  // Timeout durations
  static const Duration mediaScanTimeout = Duration(minutes: 5);
  static const Duration networkTimeout = Duration(seconds: 30);

  // Pagination
  static const int pageSize = 50;
}

