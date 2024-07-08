import 'package:agroautomated/pages/chart_page.dart';
import 'package:agroautomated/widgets/app_appbarTitle_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MyplantsPage extends StatefulWidget {
  late final String plantId;
  MyplantsPage({super.key, required this.plantId});

  @override
  _MyplantsPageState createState() => _MyplantsPageState();
}

class _MyplantsPageState extends State<MyplantsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<String> fetchSoilMoistureData() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('sensor_data')
        .child(widget.plantId)
        .child('soil_moisture_integer')
        .once();

    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value.toString();
    } else {
      throw Exception('Soil Moisture data not available');
    }
  }

  Future<String> fetchTemperature() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('sensor_data')
        .child(widget.plantId)
        .child('temperature_integer')
        .once();

    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value.toString();
    } else {
      throw Exception('Temperature data not available');
    }
  }

  Future<String> fetchHumidity() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('sensor_data')
        .child(widget.plantId)
        .child('humidity_integer')
        .once();

    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value.toString();
    } else {
      throw Exception('Humidity data not available');
    }
  }

  double waterTankData = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const AppAppBarTitle(titleText: "Plant Detail"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  // First text with style
                  TextSpan(
                    text: 'My Village',
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 50, 32),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '\n'),
                  // Second text with different style
                  TextSpan(
                    text: 'Outdoor',
                    style: TextStyle(
                      color: Color.fromARGB(255, 71, 108, 95),
                      fontSize: 20.0,
                    ),
                  ),
                ],
              )),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChartPage(
                              selectedPlantId: widget.plantId,
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.green),
                child: Text(
                  'Irrigation Plan',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: MediaQuery.of(context).size.width *
                            0.15, // Adjust size based on screen width
                      ),

                      SizedBox(
                          width:
                              10), // Adding some space between the icon and text
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the start
                        children: [
                          Text("Ankara"), // Text at the top
                          Text("Cankaya"), // Text at the bottom
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // Padding for the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.04, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.005), // Spacer between text and switch, responsive height
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors
                              .lightGreen[300], // Background color for switch
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Switch(
                              value:
                                  true, // You can set the initial value based on your requirement
                              onChanged: (bool value) {
                                // Handle the switch change here if needed
                              },
                              activeColor: Colors
                                  .green[600], // Active color for the switch
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Padding for the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Device ID:',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.04, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '11199',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.04, // Responsive font size
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Padding for the container
              child: Text(
                'Overview',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.04, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            16.0), // Adding some padding around the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Aligns children in the center vertically
                          children: [
                            Icon(
                              Icons
                                  .sunny, // Using a light bulb icon as an example
                              size: MediaQuery.of(context).size.width *
                                  0.08, // Responsive icon size
                            ),
                            SizedBox(
                                height: 8.0), // Spacer between icon and text
                            Text(
                              'LIGHT',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0), // Spacer between texts
                            Column(
                              children: [
                                Text(
                                  '35-40 %',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03, // Responsive font size
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    height:
                                        5), // Add some space between the two Text widgets
                                Text(
                                  'Optimal',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            16.0), // Adding some padding around the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Aligns children in the center vertically
                          children: [
                            Icon(
                              FontAwesomeIcons
                                  .percentage, // Using the percentage icon from Font Awesome

                              size: MediaQuery.of(context).size.width *
                                  0.08, // Responsive icon size
                            ),
                            SizedBox(
                                height: 8.0), // Spacer between icon and text
                            Text(
                              'HUMIDITY',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0), // Spacer between texts
                            Column(
                              children: [
                                FutureBuilder<String>(
                                  future: fetchHumidity(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Show a loading indicator while fetching data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      int humidityValue =
                                          int.tryParse(snapshot.data ?? '') ??
                                              0;
                                      String humidityLevelText = "";

                                      // Determine humidity level based on the value
                                      if (humidityValue > 70) {
                                        humidityLevelText = "High";
                                      } else if (humidityValue > 47) {
                                        humidityLevelText = "Optimal";
                                      } else {
                                        humidityLevelText = "Low";
                                      }

                                      return Column(
                                        children: [
                                          Text(
                                            '${snapshot.data} %', // Assuming the data is in percentage
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '$humidityLevelText',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            16.0), // Adding some padding around the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Aligns children in the center vertically
                          children: [
                            Icon(
                              FontAwesomeIcons
                                  .thermometerHalf, // Using the thermometer-half icon from Font Awesome

                              size: MediaQuery.of(context).size.width *
                                  0.08, // Responsive icon size
                            ),
                            SizedBox(
                                height: 8.0), // Spacer between icon and text
                            Text(
                              'TEMPERATURE',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0), // Spacer between texts
                            Column(
                              children: [
                                FutureBuilder<String>(
                                  future: fetchTemperature(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Show a loading indicator while fetching data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      int temperatureValue =
                                          int.tryParse(snapshot.data ?? '') ??
                                              0;
                                      String temperatureLevelText = "";

                                      // Determine temperature level based on the value
                                      if (temperatureValue > 30) {
                                        temperatureLevelText = "High";
                                      } else if (temperatureValue > 20) {
                                        temperatureLevelText = "Optimal";
                                      } else {
                                        temperatureLevelText = "Low";
                                      }

                                      return Column(
                                        children: [
                                          Text(
                                            '${snapshot.data} °C', // Assuming the data is in Fahrenheit
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '$temperatureLevelText',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            16.0), // Adding some padding around the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Aligns children in the center vertically
                          children: [
                            Icon(
                              FontAwesomeIcons
                                  .tint, // Using the tint icon from Font Awesome
// Using a light bulb icon as an example
                              size: MediaQuery.of(context).size.width *
                                  0.08, // Responsive icon size
                            ),
                            SizedBox(
                                height: 8.0), // Spacer between icon and text
                            Text(
                              'SOIL MOISTURE',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0), // Spacer between texts
                            FutureBuilder<String>(
                              future: fetchSoilMoistureData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Show a loading indicator while fetching data
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int soilMoistureValue =
                                      int.tryParse(snapshot.data ?? '') ?? 0;
                                  String moistureLevelText = "";

                                  if (soilMoistureValue > 900) {
                                    moistureLevelText = "Very low";
                                  } else if (soilMoistureValue > 800) {
                                    moistureLevelText = "Low";
                                  } else if (soilMoistureValue > 600) {
                                    moistureLevelText = "Optimal";
                                  } else {
                                    moistureLevelText = "Adequate";
                                  }

                                  return Column(
                                    children: [
                                      Text(
                                        '${snapshot.data ?? '0'}',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(
                                          height:
                                              5), // Add some space between the two Text widgets
                                      Text(
                                        '$moistureLevelText',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.4, // Adjust the width as needed
                        height: MediaQuery.of(context).size.width *
                            0.4, // Adjust the height as needed
                        child: Image.asset(
                          'lib/images/1574996.png',
                          fit: BoxFit
                              .cover, // Adjust the fit as needed (cover, contain, etc.)
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        children: [
                          Text(
                            'Water Tank Level',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02),
                          Text(
                            '%${waterTankData.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centers children horizontally

              children: [
                // Icon Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Aligns children in the center horizontally
                  children: [
                    // Icon at the top
                    Icon(
                      Icons.cloud,
                      size: 64.0,
                    ),
                    SizedBox(height: 10.0), // Spacer between icon and text
                    // Text "17 °C" below the icon
                    Text(
                      '17 °C',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width:
                      70.0, // Spacer to create space between the icon and the image-text container
                ),
                // Image and Text Container
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.3, // 30% of the screen width
                  height: MediaQuery.of(context).size.width *
                      0.6, // 60% of the screen width
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Aligns children to the top
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Aligns children in the center horizontally
                    children: [
                      Image.asset(
                        'lib/images/plant_image_new.png',
                        width: MediaQuery.of(context).size.width *
                            0.45, // 50% of the screen width
                        height: MediaQuery.of(context).size.width *
                            0.45, // 50% of the screen width
                        fit: BoxFit
                            .cover, // Adjust the fit as needed (cover, contain, etc.)
                      ),
                      Text(
                        'My Plant',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.045, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
//      bottomNavigationBar: AppBottomNavigator(),
    );
  }
}
