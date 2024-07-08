import 'package:agroautomated/models/plant.dart';
import 'package:agroautomated/services/service_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlantRepository {
  final ApiService _apiService = ApiService();

  final CollectionReference _plantsCollection =
      FirebaseFirestore.instance.collection('plants');

  Future<List<Plant>> getPlants() async {
    try {
      List<Object?> plantData = await _apiService.get(_plantsCollection.id);
      List<Plant> plants = plantData
          .map((data) => Plant.fromJson(data as Map<String, dynamic>))
          .toList();
      return plants;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPlant(Plant plant) async {
    try {
      await _apiService.post(_plantsCollection.id, plant.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlant(String plantId) async {
    try {
      await _apiService.delete(_plantsCollection.id, plantId);
    } catch (e) {
      rethrow;
    }
  }
}
