import 'dart:convert';
import 'dart:typed_data';

import 'package:agroautomated/dataPoints.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Initialize Firebase
void initializeFirebase() async {
  await Firebase.initializeApp();
}

// Fetch data from Firebase Storage
Future<List<String>> fetchData() async {
  List<String> lines = [];

  // Initialize Firebase if not already initialized
  if (Firebase.apps.isEmpty) {
    initializeFirebase();
  }

  try {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('data')
        .child('ImgK7HBzrLhoCm0xoWE2.txt');

    Uint8List? downloadedData = await ref.getData();

    if (downloadedData != null) {
      // Convert downloaded data to string
      String dataString = utf8.decode(downloadedData);

      // Split the string into lines
      lines = LineSplitter().convert(dataString);
    } else {
      print('Error: Downloaded data is null.');
    }
  } catch (e, stackTrace) {
    print('Error fetching data: $e');
    print(stackTrace);
  }

  return lines;
}

void printData() async {
  List<String> lines = await fetchData();
  print(lines.length);

  lines.forEach((line) {
    print(line);
  });
}

Future<List<SensorDataPoint>> getSensorValuesWithDates(
    String plantId, String sensorName) async {
  List<SensorDataPoint> sensorDataPoints = [];

  try {
    // Initialize Firebase if not already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('data')
        .child(plantId);

    // Download data
    Uint8List? downloadedData = await ref.getData();

    if (downloadedData != null) {
      // Convert downloaded data to string
      String dataString = utf8.decode(downloadedData);

      // Split the string into lines
      List<String> lines = LineSplitter().convert(dataString);

      // Iterate over each line and extract sensor value and date
      lines.forEach((line) {
        List<String> tokens = line.split(',');
        String timeString =
            tokens[0]; // Assuming the time is the first token in the line
        String valueString = tokens
            .firstWhere((token) => token.startsWith('$sensorName:'))
            .split(':')
            .last;
        DateTime formattedTime = _parseTimeString(timeString);
        double value = double.parse(valueString);
        sensorDataPoints
            .add(SensorDataPoint(date: formattedTime, value: value));
      });
    } else {
      print('Error: Downloaded data is null.');
    }
  } catch (e, stackTrace) {
    print('Error fetching data: $e');
    print(stackTrace);
  }

  return sensorDataPoints;
}

DateTime _parseTimeString(String timeString) {
  try {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    int second = int.parse(parts[2]);

    // Create a DateTime object with the parsed hour, minute, and second
    DateTime parsedTime = DateTime(0, 0, 0, hour, minute, second);

    return parsedTime;
  } catch (e) {
    print('Error parsing time: $e');
    return DateTime(
        0, 0, 0); // Return a default DateTime object in case of error
  }
}
