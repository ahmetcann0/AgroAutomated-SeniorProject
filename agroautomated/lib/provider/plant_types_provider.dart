import 'package:agroautomated/controllers/plant_types_controller.dart';
import 'package:agroautomated/models/plant_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plantTypeProvider =
    Provider<PlantTypeController>((ref) => PlantTypeController());

final plantTypesProvider = FutureProvider<List<PlantType>>((ref) async {
  final plantTypeController = ref.read(plantTypeProvider);

  // Fetch plant types
  return await plantTypeController.fetchPlantTypes();
});
