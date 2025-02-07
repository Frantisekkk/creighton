// lib/user.dart
class User {
  final int? id;
  final String name;
  final String email;
  final String? color; // New field for color

  User({this.id, required this.name, required this.email, this.color});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No email',
      color: json['color'] ?? 'grey', // Default color if null
    );
  }
}
