import 'package:agroautomated/controllers/plant_controller.dart';
//import 'package:agroautomated/models/plant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plantProvider =
    Provider<PlantController>((ref) => PlantController());

/*final plantsProvider = FutureProvider<List<Plant>>((ref) async {
  final plantController = ref.read(plantControllerProvider);
  return await plantController.fetchPlants();
});*/
