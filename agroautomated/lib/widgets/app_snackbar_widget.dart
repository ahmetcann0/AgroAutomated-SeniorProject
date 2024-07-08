import 'package:flutter/material.dart';

class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black87,
    double elevation = 6.0,
    TextStyle? textStyle,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        elevation: elevation,
      ),
    );
  }
}
