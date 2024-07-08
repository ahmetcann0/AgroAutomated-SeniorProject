import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppIcon extends ConsumerWidget {
  final IconData iconData;
  final Color? color;
  final double? size;

  const AppIcon({
    Key? key,
    required this.iconData,
    this.color,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return Icon(
      iconData,
      color: (appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.canvasColor
          : AppTheme.lightTheme.canvasColor),
      size: size,
    );
  }
}
