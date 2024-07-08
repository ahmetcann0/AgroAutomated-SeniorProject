import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/pages/user_edit_page.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/provider/user_provider.dart';
import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_divider_widget.dart';
import 'package:agroautomated/widgets/app_icon_widger.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/widgets/app_appbar_widget_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider.notifier).state;
    final userCollection = FirebaseFirestore.instance.collection('users');

    final appThemeState = ref.watch(appThemeStateNotifier);

    return Scaffold(
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      appBar: const AppAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return FutureBuilder<DocumentSnapshot>(
            future: userCollection.doc(currentUser.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('User not found'));
              }

              // Extract user data from snapshot
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;

              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.03,
                    horizontal: screenWidth * 0.05),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF0D986A),
                                radius: screenWidth * 0.18,
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              AppText(text: '${userData['email']}'),
                            ],
                          ),
                          Column(
                            children: [
                              AppText(
                                text:
                                    '${userData['firstName']} ${userData['lastName']}',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              AppButton(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserEditPage()),
                                    );
                                  },
                                  text: 'Edit Profile'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Switch(
                                    activeColor: Color(0xFF0D986A),
                                    value: appThemeState.isDarkModeEnabled,
                                    onChanged: (enabled) {
                                      if (enabled) {
                                        appThemeState.setDarkTheme();
                                      } else {
                                        appThemeState.setLigthTheme();
                                      }
                                    },
                                  ),
                                  AppText(text: 'Dark Mode'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            const ListTile(
                              leading: AppIcon(iconData: Icons.sync),
                              title: AppText(text: 'Sync'),
                              trailing:
                                  AppIcon(iconData: Icons.arrow_forward_ios),
                            ),
                            AppDivider(height: screenHeight),
                            const ListTile(
                              leading: AppIcon(iconData: Icons.language),
                              title: AppText(text: 'Language'),
                              trailing:
                                  AppIcon(iconData: Icons.arrow_forward_ios),
                            ),
                            AppDivider(height: screenHeight),
                            const ListTile(
                              leading: AppIcon(iconData: Icons.security),
                              title: AppText(text: 'Security'),
                              trailing:
                                  AppIcon(iconData: Icons.arrow_forward_ios),
                            ),
                            AppDivider(height: screenHeight),
                            const ListTile(
                              leading: AppIcon(iconData: Icons.info),
                              title: AppText(text: 'About'),
                              trailing:
                                  AppIcon(iconData: Icons.arrow_forward_ios),
                            ),
                            AppDivider(height: screenHeight),
                            const ListTile(
                              leading: AppIcon(iconData: Icons.feedback),
                              title: AppText(text: 'Feedback'),
                              trailing:
                                  AppIcon(iconData: Icons.arrow_forward_ios),
                            ),
                            AppDivider(height: screenHeight),
                            ListTile(
                              leading: const AppIcon(iconData: Icons.logout),
                              title: const AppText(text: 'Log out'),
                              trailing: const AppIcon(
                                  iconData: Icons.arrow_forward_ios),
                              onTap: () {
                                signUserOut(context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> signUserOut(BuildContext context) async {
  FirebaseAuth.instance.signOut();
}
