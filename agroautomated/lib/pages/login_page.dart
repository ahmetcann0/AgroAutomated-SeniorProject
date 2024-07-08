import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/tokenFunctions.dart';
import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_snackbar_widget.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:agroautomated/widgets/app_textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    /*  showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    ); */
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      updateUserFCMToken();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User not found.';
          break;
        case 'wrong-password':
          errorMessage = 'The password is invalid';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          errorMessage = 'Email and password do not match.';
          break;
        default:
          errorMessage = e.code;
      }

      AppSnackBar.show(
        context: context,
        message: errorMessage,
        backgroundColor: Colors.red,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height * 0.018,
        ),
      );

      print(e);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    // Access the MediaQuery data
    final mediaQueryData = MediaQuery.of(context);

    // Get the screen width and height
    // final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;

    return Scaffold(
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set width to screen width
              child: Image.asset(
                'lib/images/Rectangle 495.png',
                fit: BoxFit
                    .cover, // Apply BoxFit.cover to cover the entire space
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Image.asset(
              'lib/images/GreenGenieLogocropped7-removebg-preview.png',
              width: 46,
              height: 48,
            ),
            RichText(
              text: TextSpan(
                text: 'Agro',
                style: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Automated',
                    style: TextStyle(
                      color: Color.fromARGB(255, 21, 145, 72),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  AppText(
                    text: 'Welcome Back',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                  ),
                  const AppText(text: 'Log in to your account'),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  AppTextField(
                    controller: emailController,
                    labelText: 'E-mail',
                    hintText: 'Enter your e-mail',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AppTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const AppText(text: 'Forgot Password?'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: screenHeight * 0.06,
              child: AppButton(
                onTap: () {
                  signUserIn(context);
                },
                text: 'Login',
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            GestureDetector(
              onTap: onTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: 'Don’t have an account? ',
                    fontSize: 16.0,
                  ),
                  AppText(
                    text: 'Signup',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xFF0D986A),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
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
      ),
    );
  }
}
