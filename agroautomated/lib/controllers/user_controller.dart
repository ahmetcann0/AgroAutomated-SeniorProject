import 'package:agroautomated/models/user.dart';
import 'package:agroautomated/repositories/user_repository.dart';

class UserController {
  final UserRepository _userRepository = UserRepository();

  Future<List<User>> fetchUsers() async {
    try {
      List<User> users = await _userRepository.getUsers();
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    await _userRepository.deleteUser(userId);
  }
}
