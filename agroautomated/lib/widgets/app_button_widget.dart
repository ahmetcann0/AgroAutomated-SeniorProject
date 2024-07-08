import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppButton extends ConsumerWidget {
  final Function()? onTap;
  final String text;

  const AppButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return ElevatedButton(
      onPressed: () {
        onTap?.call(); // Call the onTap function if it's not null
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: appThemeState.isDarkModeEnabled
            ? AppTheme.darkTheme.primaryColor // Dark mode primary color
            : AppTheme.lightTheme.primaryColor, // Light mode primary color
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.045,
        ),
      ),
    );
  }
}
