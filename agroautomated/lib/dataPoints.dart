class DataPoint {
  final double x;
  final double y;

  DataPoint({required this.x, required this.y});
}

class SensorDataPoint {
  final DateTime date;
  final double value;

  SensorDataPoint({required this.date, required this.value});
}

final dateMap = {
  'day': 'Day',
  'week': 'Week',
  'month': 'Month',
  'total': 'Total'
};
String _selectedDate = dateMap.keys.first;

final sensorMap = {
  'weather_humidity': 'Weather Humidity',
  'weather_temperature': 'Weather Temperature',
  'soil_moisture': 'Soil Moisture',
  'water_level': 'Water Tank Level',
  'temperature': 'Temperature',
  'conductivity': 'Conductivity',
  'ph': 'Ph',
  'nitrogen': 'Nitrogen',
  'phosporus': 'Phosphorus',
  'potasium': 'Potassium',
};
