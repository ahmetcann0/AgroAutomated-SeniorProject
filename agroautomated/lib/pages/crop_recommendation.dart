import 'package:agroautomated/widgets/app_button_widget.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CropRecommendationSheet extends StatefulWidget {
  final String plantId;

  const CropRecommendationSheet({Key? key, required this.plantId})
      : super(key: key);

  @override
  _CropRecommendationSheetState createState() =>
      _CropRecommendationSheetState();
}

class _CropRecommendationSheetState extends State<CropRecommendationSheet> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Future<String>? _recommendedCrop;

  Future<String> fetchSensorData(String sensorType) async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('sensor_data')
        .child(widget.plantId)
        .child(sensorType)
        .once();

    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value.toString();
    } else {
      throw Exception('$sensorType data not available');
    }
  }

  void _getRecommendedCrop() {
    setState(() {
      _recommendedCrop = Future.delayed(
        Duration(seconds: 1),
        () => fetchSensorData('Recommended Crop'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            onTap: _getRecommendedCrop,
            text: 'Recommend Crop',
          ),
          SizedBox(height: 16.0),
          FutureBuilder<String>(
            future: _recommendedCrop,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: Colors.green,
                ); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String recommendedCropValue = snapshot.data ??
                    "Make sure the sensor is properly placed in the soil.";
                return AppText(
                  text: recommendedCropValue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
