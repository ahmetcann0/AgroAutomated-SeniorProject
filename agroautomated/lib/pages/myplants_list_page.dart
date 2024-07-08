import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/pages/myplants_page.dart';
import 'package:agroautomated/provider/plant_provider.dart';
import 'package:agroautomated/provider/theme_provider.dart';
//import 'package:agroautomated/provider/theme_provider.dart';
import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_icon_widger.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/widgets/app_appbar_widget_page.dart';
import 'package:agroautomated/pages/add_plant_bottomsheet_widget.dart';

class MyPlantsListPage extends ConsumerStatefulWidget {
  const MyPlantsListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyPlantsListPageState createState() => _MyPlantsListPageState();
}

class _MyPlantsListPageState extends ConsumerState<MyPlantsListPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final plantController = ref.watch(plantProvider);

    late final user = FirebaseAuth.instance.currentUser!;
    final appThemeState = ref.watch(appThemeStateNotifier);

    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenHeight * 0.02;

    return Scaffold(
      appBar: const AppAppBar(),
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                    text: 'My Plants',
                    fontSize: 2 * fontSize,
                    fontWeight: FontWeight.bold),
                AppButton(
                  onTap: () {
                    PlantBottomSheet.show(context);
                  },
                  text: ('Add Plant'),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              style: TextStyle(
                  color: appThemeState.isDarkModeEnabled
                      ? AppTheme.darkTheme.canvasColor
                      : AppTheme.lightTheme.canvasColor), // Text color
              decoration: InputDecoration(
                labelText: 'Search', // Label text
                labelStyle: TextStyle(color: Colors.grey), // Label text color
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      _searchQuery = '';
                    });
                  },
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0), // Padding inside the TextField
                filled: true, // Enable filled background
                fillColor: appThemeState.isDarkModeEnabled
                    ? Colors.grey[800]
                    : Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                      color: Colors
                          .white70), // Border color when the TextField is enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Border color when the TextField is focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('plants') // Updated to 'plants' collection
                  .where('userId',
                      isEqualTo: user.uid) // Filter by current user's ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }

                List<DocumentSnapshot> plantDocs = snapshot.data!.docs;

                // Filter plants based on search query
                List<DocumentSnapshot> filteredPlants =
                    plantDocs.where((plantDoc) {
                  String title = plantDoc['title'].toString().toLowerCase();
                  String type = plantDoc['type'].toString().toLowerCase();
                  String searchQueryLower = _searchQuery.toLowerCase();

                  return title.contains(searchQueryLower) ||
                      type.contains(searchQueryLower);
                }).toList();

                return ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plantData =
                        filteredPlants[index].data() as Map<String, dynamic>;

                    String title = plantData['title'];
                    String type = plantData['type'];
                    bool isIndoor = plantData['isIndoor'];
                    String location = plantData['location'];

                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyplantsPage(
                                    plantId: filteredPlants[index]
                                        .id), // Navigate to your desired page
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: appThemeState.isDarkModeEnabled
                                ? Colors.black45
                                : Colors.green[100],
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppText(
                                            text: title,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize * 1.5),
                                        SizedBox(height: 3.0),
                                        AppText(
                                            text:
                                                isIndoor ? 'Indoor' : 'Outdoor',
                                            fontSize: fontSize),
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  AppIcon(
                                                    iconData: Icons.location_on,
                                                    size:
                                                        30.0, // Increase the size of the icon
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          10.0), // Add spacing between icon and text
                                                  AppText(
                                                    text: location,

                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        18.0, // Increase the font size of the text
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    AppIcon(
                                                      iconData:
                                                          Icons.water_drop,
                                                      size: 30.0,
                                                    ), // Waterdrop icon
                                                    SizedBox(
                                                        width:
                                                            5.0), // Add spacing between icon and text
                                                    AppText(
                                                      text: 'Automatic',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: fontSize,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  plantController.deletePlant(
                                                      filteredPlants[index].id);
                                                },
                                                child: Icon(Icons.delete),
                                              )
                                            ],
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 160,
                                        child: Image.asset(
                                          'lib/images/plant_image_new.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      AppText(
                                          text: type,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
