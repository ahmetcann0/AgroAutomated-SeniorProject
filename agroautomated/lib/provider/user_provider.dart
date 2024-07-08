import 'package:agroautomated/controllers/user_controller.dart';
import 'package:agroautomated/models/user.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider =
    Provider<UserController>((ref) => UserController());

final usersProvider = FutureProvider<List<u.User>>((ref) async {
  final userController = ref.read(userControllerProvider);
  return userController.fetchUsers();
});

final userProvider =
    StateProvider<User?>((ref) => FirebaseAuth.instance.currentUser);
