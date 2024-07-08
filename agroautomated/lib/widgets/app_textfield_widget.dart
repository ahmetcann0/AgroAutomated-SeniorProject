import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/provider/theme_provider.dart';

class AppTextField extends ConsumerWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final bool obscureText;

  const AppTextField({
    Key? key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor:
          appThemeState.isDarkModeEnabled ? Colors.white : Colors.black,
      style: TextStyle(
        color: appThemeState.isDarkModeEnabled ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color:
                appThemeState.isDarkModeEnabled ? Colors.white : Colors.black,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: appThemeState.isDarkModeEnabled
                ? Colors.white38
                : Colors.black54,
            width: 0.5,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor:
            appThemeState.isDarkModeEnabled ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        labelStyle: TextStyle(
          color: appThemeState.isDarkModeEnabled ? Colors.white : Colors.black,
        ),
        hintStyle: TextStyle(
          color:
              appThemeState.isDarkModeEnabled ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }
}
