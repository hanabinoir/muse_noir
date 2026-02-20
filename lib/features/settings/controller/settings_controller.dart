import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings controller for managing app settings
class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  /// Toggle theme between light and dark
  void toggleTheme() {
    // To be implemented with theme state
  }

  /// Get current theme setting
  bool isDarkMode() {
    // To be implemented
    return true;
  }
}

/// Settings controller provider
final settingsControllerProvider = Provider((ref) {
  return SettingsController(ref);
});


