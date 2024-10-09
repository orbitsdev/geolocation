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
    id: json['id'],  // Nullable
    firstName: json['first_name'] ?? null,  // This ensures 'null' is handled correctly
    lastName: json['last_name'] ?? null,    // This allows for null values
    fullName: json['full_name'] ?? null,    
    email: json['email'] ?? null,          
    role: json['role'] ?? null,            // Null is expected here since role might be null
    image: json['image'] ?? null,          // Image might be null
    councilPositions: (json['council_positions'] as List?)?.map((position) => CouncilPosition.fromJson(position)).toList() ?? [],  // Handle null positions list
    defaultPosition: json['default_position'] != null ? CouncilPosition.fromJson(json['default_position']) : null,  // Handle nullable default position
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
