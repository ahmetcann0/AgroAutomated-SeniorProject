class Plant {
  final String title;
  final String type;
  final String location;
  final bool isIndoor;
  final bool notification;
  final String userId;

  Plant({
    required this.title,
    required this.type,
    required this.location,
    required this.isIndoor,
    this.notification = true,
    required this.userId,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      isIndoor: json['isIndoor'] ?? false,
      notification: json['notification'] ?? true,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'location': location,
      'isIndoor': isIndoor,
      'notification': notification,
      'userId': userId,
    };
  }
}
