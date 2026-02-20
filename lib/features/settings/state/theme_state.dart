import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme state provider
class ThemeState {
  final bool isDarkMode;

  const ThemeState({
    required this.isDarkMode,
  });

  ThemeState copyWith({
    bool? isDarkMode,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

/// Theme state notifier
class ThemeStateNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState(isDarkMode: true);
  }

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }
}

/// Theme provider
final themeStateProvider =
    NotifierProvider<ThemeStateNotifier, ThemeState>(() {
  return ThemeStateNotifier();
});


