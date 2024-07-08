import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';

class AppText extends ConsumerWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;

  const AppText(
      {super.key,
      required this.text,
      this.color,
      this.fontSize = 14.0,
      this.fontWeight = FontWeight.normal,
      this.textAlign,
      this.decoration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return Text(
      text,
      style: TextStyle(
        color: color ??
            (appThemeState.isDarkModeEnabled
                ? AppTheme.darkTheme.canvasColor
                : AppTheme.lightTheme.canvasColor),
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
      textAlign: textAlign,
    );
  }
}
