import 'package:agroautomated/pages/login_page.dart';
import 'package:agroautomated/pages/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrSingupPage extends StatefulWidget {
  const LoginOrSingupPage({super.key});

  @override
  State<LoginOrSingupPage> createState() => _LoginOrSingupPageState();
}

class _LoginOrSingupPageState extends State<LoginOrSingupPage> {
  // initially show login page
  bool showLoginPage = true;

// toggle between login and register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: () {
          togglePages();
          // After successful login, update FCM token in Firestore
        },
      );
    } else {
      return SignupPage(
        onTap: togglePages,
      );
    }
  }
}
