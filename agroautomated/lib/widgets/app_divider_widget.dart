import 'package:agroautomated/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDivider extends ConsumerWidget {
  final double height;
  final double? thickness;

  const AppDivider({
    Key? key,
    required this.height,
    this.thickness = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return Divider(
      thickness: thickness,
      color: (appThemeState.isDarkModeEnabled
          ? Colors.grey[800]
          : Colors.grey[300]),
    );
  }
}
