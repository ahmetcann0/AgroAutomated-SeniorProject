// models/plant_type.dart
class PlantType {
  final String name;

  PlantType({
    required this.name,
  });

  factory PlantType.fromJson(Map<String, dynamic> json) {
    return PlantType(
      name: json['name'] ?? '',
    );
  }
}
