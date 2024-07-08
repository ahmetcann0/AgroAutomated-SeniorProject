/*import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/functions/notification_helper.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/widgets/app_appbar_widget_page.dart';

class GuidePage extends ConsumerStatefulWidget {
  GuidePage({Key? key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends ConsumerState<GuidePage> {
  @override
  Widget build(BuildContext context) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    // Method to show an instant notification
    void showInstantNotification() {
      NotificationHelper.showNotification(
        id: 0,
        title: 'Instant Notification',
        body: 'This is an instant notification',
        payload: 'payload_data',
      );
    }

    return Scaffold(
      appBar: AppAppBar(),
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: AppText(text: 'This is the Guide Page', fontSize: 20.0),
            ),
            ElevatedButton(
              onPressed:
                  showInstantNotification, // Call the method to show notification
              child: Text('Show Instant Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
*/