import 'package:flutter/material.dart';

/// Theme toggle widget for settings
class ThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      onChanged: onChanged,
      activeColor: Colors.purple,
      activeTrackColor: Colors.purple.withOpacity(0.5),
    );
  }
}

