import 'package:geolocation/features/members/model/concil_position.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? role;
  final String? image;
  final List<CouncilPosition>? councilPositions;
  final CouncilPosition? defaultPosition;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.role,
    this.image,
    this.councilPositions,
    this.defaultPosition,
  });

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'], // Snake case in the API, camelCase in Dart
      lastName: json['last_name'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      image: json['image'],
      councilPositions: (json['council_positions'] as List?)
          ?.map((position) => CouncilPosition.fromJson(position))
          .toList(),
      defaultPosition: json['default_position'] != null
          ? CouncilPosition.fromJson(json['default_position'])
          : null,
    );
  }

  // Convert User object to JSON for storage if necessary
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'role': role,
      'image': image,
      'council_positions': councilPositions?.map((e) => e.toJson()).toList(),
      'default_position': defaultPosition?.toJson(),
    };
  }
}
