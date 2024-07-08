// Function to update FCM token in Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Function to update FCM token in Firestore
Future<void> updateUserFCMToken() async {
  final messaging = FirebaseMessaging.instance;
  String? newToken = await messaging.getToken();
  String? currentToken = await getCurrentUserFCMToken();

  if (currentToken != null) {
    // Retrieve the current FCM token from Firestore (if available)

    // Check if the new token is different from the current token
    if (currentToken != newToken) {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's FCM token in Firestore
      await updateUserDocumentWithToken(userId, newToken!);
    }
  }
}

// Function to retrieve the current user's FCM token from Firestore
Future<String?> getCurrentUserFCMToken() async {
  // Retrieve the current user's document from Firestore
  String userId = FirebaseAuth
      .instance.currentUser!.uid; // replace '' with the actual user ID
  DocumentSnapshot userSnapshot = await _getUser(userId);

  // Access the 'fcmToken' field from the document
  String? currentToken = userSnapshot['fcmToken'];

  // Return the current FCM token
  return currentToken;
}

// Function to update the user's FCM token in Firestore
Future<void> updateUserDocumentWithToken(String userId, String newToken) async {
  // Logic to update the user's FCM token in Firestore
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({'fcmToken': newToken});
}

Future<DocumentSnapshot> _getUser(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}
