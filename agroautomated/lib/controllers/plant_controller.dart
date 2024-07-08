import 'package:agroautomated/models/plant.dart';
import 'package:agroautomated/repositories/plant_repository.dart';

class PlantController {
  final PlantRepository _plantRepository = PlantRepository();

  Future<List<Plant>> fetchPlants() async {
    try {
      List<Plant> plants = await _plantRepository.getPlants();
      return plants;
    } catch (e) {
      print('Error fetching plants: $e');
      throw e;
    }
  }

  Future<void> addPlant(Plant plant) async {
    try {
      await _plantRepository.addPlant(plant);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlant(String plantId) async {
    await _plantRepository.deletePlant(plantId);
  }
}
