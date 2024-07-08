import 'package:firebase_storage/firebase_storage.dart';

Future<String> getFileURL(String filePath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadURL = await storage.ref(filePath).getDownloadURL();
  return downloadURL;
}
