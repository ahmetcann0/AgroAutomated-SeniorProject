import 'package:agroautomated/app_theme.dart';

import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_plant_cart.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/widgets/app_appbar_widget_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final user = FirebaseAuth.instance.currentUser!;
  late final Future<DocumentSnapshot> _userData = _getUser(user.uid);

  @override
  void initState() {
    super.initState();
  }

  void singUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return Scaffold(
      appBar: const AppAppBar(),
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      body: Center(
        child: FutureBuilder(
          future: _userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(); // or any loading widget
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final firstName = snapshot.data!.get('firstName');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                    AppText(
                      text: "Welcome $firstName",
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: Image.asset(
                        'lib/images/coverBanner kopyası.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.03,
                    ),
                    AppText(
                      text: "Plant Overview",
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    Expanded(
                      child:
                          AppPlantCart(), // Use the updated AppPlantCart widget
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _getUser(String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
  }
}
