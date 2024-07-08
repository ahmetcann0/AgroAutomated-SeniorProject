import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDarkModeEnabled;
  final Function(bool) onThemeChanged;

  const ThemeSwitch({
    required this.isDarkModeEnabled,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isDarkModeEnabled,
          onChanged: onThemeChanged,
        ),
        const Text('Dark Mode'),
      ],
    );
  }
}
