import 'package:agroautomated/models/plant_types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlantTypeRepository {
  final CollectionReference _plantTypesCollection =
      FirebaseFirestore.instance.collection('plant_types');

  Future<List<PlantType>> getPlantTypes() async {
    QuerySnapshot querySnapshot = await _plantTypesCollection.get();
    List<PlantType> plantTypes = querySnapshot.docs
        .map((doc) => PlantType.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return plantTypes;
  }
}
