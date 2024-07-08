import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/provider/theme_provider.dart';

// Define a class to hold plant information
class PlantInfo {
  final String name;
  final List<SensorInfo> sensors;

  PlantInfo({
    required this.name,
    required this.sensors,
  });
}

class AppPlantCart extends StatelessWidget {
  // Example plant data (replace with your actual data)

  final List<PlantInfo> plants = [
    PlantInfo(
      name: "Plant A",
      sensors: [
        SensorInfo(name: "Temperature", value: 25.0, isOptimal: true),
        SensorInfo(name: "Humidity", value: 60.0, isOptimal: false),
        // Add more sensors for Plant A
      ],
    ),
    PlantInfo(
      name: "Plant B",
      sensors: [
        SensorInfo(name: "Temperature", value: 22.0, isOptimal: true),
        SensorInfo(name: "Humidity", value: 65.0, isOptimal: true),
        // Add more sensors for Plant B
      ],
    ),
    // Add more plants here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: plants.length,
      itemBuilder: (context, index) {
        PlantInfo plant = plants[index];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
          color: Colors.green[100],
          child: Center(
            child: Column(
              children: [
                Text(
                  plant.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: plant.sensors.map((sensor) {
                    IconData iconData =
                        sensor.isOptimal ? Icons.check : Icons.error;
                    Color iconColor =
                        sensor.isOptimal ? Colors.green : Colors.red;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${sensor.name}: ${sensor.value}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          iconData,
                          size: 30,
                          color: iconColor,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Define a class to hold sensor information
class SensorInfo {
  final String name;
  final double value;
  final bool isOptimal;

  SensorInfo({
    required this.name,
    required this.value,
    required this.isOptimal,
  });
}
