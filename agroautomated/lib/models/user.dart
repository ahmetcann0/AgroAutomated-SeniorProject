// models/user.dart
class User {
  final String userId;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  String? fcmToken; // New field to store FCM token

  User({
    required this.userId,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.fcmToken, // Make the fcmToken field nullable
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      address: json['address'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fcmToken: json['fcmToken'], // Assign the fcmToken value from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fcmToken': fcmToken, // Include the fcmToken value in the JSON map
    };
  }
}
