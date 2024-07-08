import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const AppAppBarTitle({Key? key, required this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double titleFontSize = screenWidth * 0.055;

    return Consumer(
      builder: (context, ref, child) {
        final appThemeState = ref.watch(appThemeStateNotifier);

        return AppBar(
          backgroundColor: appThemeState.isDarkModeEnabled
              ? AppTheme.darkTheme.bottomAppBarTheme.color
              : AppTheme.lightTheme.bottomAppBarTheme.color,
          iconTheme: IconThemeData(
              color: appThemeState.isDarkModeEnabled
                  ? AppTheme.darkTheme.canvasColor
                  : AppTheme.lightTheme.canvasColor),
          title: AppText(
            text: titleText,
            color: const Color.fromARGB(255, 21, 145, 72),
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          toolbarHeight: screenHeight * 0.5,
          centerTitle: true, // Center the title text
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.3);
}
