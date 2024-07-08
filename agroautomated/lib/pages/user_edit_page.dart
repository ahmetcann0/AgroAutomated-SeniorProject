import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroautomated/widgets/app_appbar_widget_page.dart';

class UserEditPage extends ConsumerStatefulWidget {
  UserEditPage({Key? key}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends ConsumerState<UserEditPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _addressController.text = userData['address'];
        _firstNameController.text = userData['firstName'];
        _lastNameController.text = userData['lastName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final appThemeState = ref.watch(appThemeStateNotifier);

    return Scaffold(
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      appBar: const AppAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextField(
              controller: _firstNameController,
              labelText: 'First Name',
              hintText: 'Enter your first name',
            ),
            SizedBox(height: screenHeight * 0.03),
            AppTextField(
              controller: _lastNameController,
              labelText: 'Last Name',
              hintText: 'Enter your last name',
            ),
            SizedBox(height: screenHeight * 0.03),
            AppTextField(
              controller: _addressController,
              labelText: 'Address',
              hintText: 'Enter your address',
            ),
            SizedBox(height: screenHeight * 0.03),
            AppButton(
              onTap: () {
                updateUserInformation(context);
              },
              text: ('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserInformation(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(
          {
            'address': _addressController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'userId': user.uid,
          },
        );
        Navigator.pop(context); // Navigate back to the user page
      } catch (e) {
        print('Error updating user information: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Error updating user information. Please try again later.'),
        ));
      }
    }
  }
}
