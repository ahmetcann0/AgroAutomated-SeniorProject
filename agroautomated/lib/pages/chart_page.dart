import 'package:agroautomated/widgets/app_appbarTitle_widget.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/dataPoints.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/testdata_page.dart'; // Import the necessary files
import 'package:agroautomated/lineChart.dart';
import 'package:intl/intl.dart'; // Import the LineChartWidget

class ChartPage extends ConsumerStatefulWidget {
  late final String selectedPlantId;

  ChartPage({Key? key, required this.selectedPlantId}) : super(key: key);

  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends ConsumerState<ChartPage> {
  late Future<List<SensorDataPoint>> sensorValues;
  String _selectedSensorName =
      sensorMap.keys.first; // Added sensorName variable

  @override
  void initState() {
    super.initState();
    // Assuming you have a provider called currentPlantIdProvider
    fetchSensorData(widget.selectedPlantId, _selectedSensorName);
  }

  void fetchSensorData(String plantId, String sensorName) async {
    // to get storage txt file we added .txt
    sensorValues = getSensorValuesWithDates("$plantId.txt", sensorName);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('d MMM yyyy - HH:mm').format(now);

    final appThemeState = ref.watch(appThemeStateNotifier);

    String selectedDate = dateMap.keys.first;

    final sensorTypeDropdown = DropdownButtonFormField<String>(
      iconSize: 24, // Size of the dropdown icon
      elevation: 16, // Elevation of the dropdown menu
      style: TextStyle(color: Colors.black), // Style for the selected item

      decoration: InputDecoration(
        labelText: 'Select Sensor Type',
        labelStyle: TextStyle(
          color: appThemeState.isDarkModeEnabled
              ? AppTheme.darkTheme.primaryColor
              : AppTheme.lightTheme
                  .primaryColor, // Change this color to the desired color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: appThemeState.isDarkModeEnabled
                ? AppTheme.darkTheme.primaryColor
                : AppTheme.lightTheme
                    .primaryColor, // Change this color to the desired color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: appThemeState.isDarkModeEnabled
                ? AppTheme.darkTheme.primaryColor
                : AppTheme.lightTheme.primaryColor,
          ),
        ),
        filled: true,
        fillColor: appThemeState.isDarkModeEnabled
            ? Colors.grey[800]
            : Colors.grey[200],
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),

      value: _selectedSensorName,
      onChanged: (newValue) {
        setState(() {
          _selectedSensorName = newValue!;
          fetchSensorData(widget.selectedPlantId,
              _selectedSensorName); // Fetch new sensor data
        });
      },
      items: sensorMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );

    final dateTypeSelectionTile = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          CupertinoRadioChoice(
            choices: dateMap,
            selectedColor: AppTheme.darkTheme.primaryColor,
            onChange: (String sensorKey) {
              setState(() {
                selectedDate = sensorKey;
              });
            },
            initialKeyValue: selectedDate,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppAppBarTitle(
        titleText: ('Charts'), // Set the title of the app bar
      ),
      backgroundColor: appThemeState.isDarkModeEnabled
          ? AppTheme.darkTheme.dialogBackgroundColor
          : AppTheme.lightTheme.dialogBackgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            AppText(
              text: formattedTime,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: sensorTypeDropdown,
            ),
            SizedBox(height: 10),
            dateTypeSelectionTile,
            FutureBuilder<List<SensorDataPoint>>(
              future: sensorValues,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  List<SensorDataPoint> sensorDataPoints = snapshot.data!;
                  // Process sensorDataPoints her

                  return LineChartWidget(sensorDataPoints);
                }
                return Container();
              },
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: "Max Değer: ", fontWeight: FontWeight.bold),
                    AppText(text: "Min Değer: ", fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: "Geçen Ay/Hafta Ortalama Değişim: ",
                        fontWeight: FontWeight.bold),
                    AppText(
                        text: "Ortalama Değişim Hızı: ",
                        fontWeight: FontWeight.bold),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
