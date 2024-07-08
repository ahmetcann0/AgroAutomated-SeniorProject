import 'package:agroautomated/models/user.dart';
import 'package:agroautomated/services/service_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<User>> getUsers() async {
    try {
      List<Object?> userData = await _apiService.get(_usersCollection.id);
      List<User> users = userData
          .map((data) => User.fromJson(data as Map<String, dynamic>))
          .toList();
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _apiService.put(_usersCollection.id, user.userId, user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _apiService.delete(_usersCollection.id, userId);
    } catch (e) {
      rethrow;
    }
  }
}
