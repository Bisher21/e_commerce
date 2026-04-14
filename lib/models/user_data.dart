class UserData {
  final String id;
  final String email;
  final String name;
  final String createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': name,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['displayName'],
      createdAt: map['createdAt'],
    );
  }
}
