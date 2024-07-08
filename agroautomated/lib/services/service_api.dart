//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Object?>> get(String collectionName) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> put(String collectionName, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(String collectionName, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).add(data);
    } catch (e) {
      rethrow;
    }
  }
}
