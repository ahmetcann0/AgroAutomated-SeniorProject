import 'package:agroautomated/pages/login_or_signup_page.dart';
import 'package:agroautomated/widgets/app_bottom_nav_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const AppBottomNavigator();
            } else {
              return const LoginOrSingupPage();
            }
          }),
    );
  }
}
