// ignore_for_file: file_names
//import 'package:agroautomated/app_theme.dart';
//import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_snackbar_widget.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:agroautomated/widgets/app_textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final acceptTermsProvider =
    StateNotifierProvider<AcceptTermsNotifier, bool>((ref) {
  return AcceptTermsNotifier();
});

class AcceptTermsNotifier extends StateNotifier<bool> {
  AcceptTermsNotifier() : super(false);

  void setAcceptTerms(bool value) {
    state = value;
  }
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final addressController = TextEditingController();

void addUserDetails(String firstName, String lastName, String email,
    String address, String userId) async {
  try {
    final messaging = FirebaseMessaging.instance;
    String? newToken = await messaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'fcmToken': newToken // Add FCM token to user details
    });
  } catch (e) {
    print('Error adding user details to Firestore: $e');
  }
}

void signUserUp(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  // creating user account parts
  try {
    // Ensure passwords match before creating the user
    if (passwordController.text == confirmPasswordController.text) {
      // Check if essential information is provided
      if (firstNameController.text.trim().isEmpty ||
          lastNameController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty) {
        AppSnackBar.show(
          context: context,
          message: 'Please fill in all fields',
          backgroundColor: Colors.red,
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height * 0.018),
        );
      } else {
        // Create user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Extract user ID from Firebase Authentication
        String userId = userCredential.user!.uid;

        // Add user details to Firestore using the Firebase Authentication user ID
        addUserDetails(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          addressController.text.trim(),
          userId,
        );
      }
    } else {
      // Passwords do not match
      AppSnackBar.show(
        context: context,
        message: 'Passwords do not match',
        backgroundColor: Colors.red,
        textStyle: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height * 0.018),
      );
    }
  } on FirebaseAuthException catch (e) {
    // Handle FirebaseAuthException
    print('FirebaseAuthException: ${e.message}');
  } catch (e) {
    // Handle other exceptions
    print('Error: $e');
  }

// Navigate back
  Navigator.pop(context);
}

class SignupPage extends ConsumerWidget {
  final Function()? onTap;
  SignupPage({Key? key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool acceptTerms = ref.watch(acceptTermsProvider);
    final appThemeState = ref.watch(appThemeStateNotifier);

    final mediaQueryData = MediaQuery.of(context);

    // Get the screen width and height
    //final screenWidth = mediaQueryData.size.width;
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
            SizedBox(height: screenHeight * 0.01),
            Image.asset(
              'lib/images/GreenGenieLogocropped7-removebg-preview.png',
              width: 46,
              height: 48,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: 'Agro',
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                AppText(
                  text: 'Automated',
                  color: Color.fromARGB(255, 21, 145, 72),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    AppTextField(
                      controller: firstNameController,
                      labelText: 'First Name',
                      hintText: 'Enter first name',
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    AppTextField(
                      controller: lastNameController,
                      labelText: 'Last Name',
                      hintText: 'Enter last name',
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    AppTextField(
                      controller: addressController,
                      labelText: 'Address',
                      hintText: 'Enter address',
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    AppTextField(
                      controller: emailController,
                      labelText: 'E-mail',
                      hintText: 'Enter E-mail',
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    AppTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Enter password',
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    AppTextField(
                      controller: confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Enter password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: appThemeState.isDarkModeEnabled
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    child: Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        ref
                            .read(acceptTermsProvider.notifier)
                            .setAcceptTerms(value!);
                      },
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // Adjusts the tap target size
                      activeColor: const Color(0xFF159148),
                      checkColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'By signing up you agree to our ',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: appThemeState.isDarkModeEnabled
                                ? Colors.grey[300]
                                : Colors.grey[700]),
                        children: [
                          TextSpan(
                            text: 'terms & conditions',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                              color: Color(0xFF0D986A),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the click on 'terms & conditions'
                                print('Terms & Conditions clicked');
                              },
                          ),
                          TextSpan(
                            text: ' of use and ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: appThemeState.isDarkModeEnabled
                                    ? Colors.grey[300]
                                    : Colors.grey[700]),
                          ),
                          TextSpan(
                            text: 'privacy policy.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                              color: Color(0xFF0D986A),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the click on 'privacy policy'
                                print('Privacy Policy clicked');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60.0,
                child: AppButton(
                  onTap: () {
                    signUserUp(
                        context); // This is a void function, so it doesn't fit the expected signature of VoidCallback
                  },
                  text: 'SIGN UP',
                )),
            SizedBox(height: screenHeight * 0.02),
            InkWell(
              child: GestureDetector(
                onTap: onTap,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: 'Already have an account? ',
                      fontSize: 16.0,
                    ),
                    AppText(
                      text: 'Login',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xFF0D986A),
                      decoration: TextDecoration.underline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
