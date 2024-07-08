import 'package:agroautomated/models/plant_types.dart';
import 'package:agroautomated/repositories/plant_types_repository.dart';

class PlantTypeController {
  final PlantTypeRepository _plantTypeRepository = PlantTypeRepository();

  Future<List<PlantType>> fetchPlantTypes() async {
    return await _plantTypeRepository.getPlantTypes();
  }
}
