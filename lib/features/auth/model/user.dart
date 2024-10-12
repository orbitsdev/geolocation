// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
     councilPositions: (json['council_positions'] as List?)
            ?.map((position) => CouncilPosition.fromJson(position))
            .toList() ??
        [],
    defaultPosition: json['default_position'] != null
        ? CouncilPosition.fromJson(json['default_position'])
        : null, // Handle null default positionndle nullable default position
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

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? role,
    String? image,
    List<CouncilPosition>? councilPositions,
    CouncilPosition? defaultPosition,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      image: image ?? this.image,
      councilPositions: councilPositions ?? this.councilPositions,
      defaultPosition: defaultPosition ?? this.defaultPosition,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, fullName: $fullName, email: $email, role: $role, image: $image, councilPositions: $councilPositions, defaultPosition: $defaultPosition)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'role': role,
      'image': image,
      'council_position': councilPositions!= null?  councilPositions?.map((x) => x.toMap()).toList() : [],
      'defaultPosition': defaultPosition?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      firstName: map['first_name'] != null ? map['first_name'] as String : null,
      lastName: map['last_name'] != null ? map['last_name'] as String : null,
      fullName: map['full_name'] != null ? map['full_name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      councilPositions: map['council_position'] != null ? List<CouncilPosition>.from((map['council_position'] as List<CouncilPosition>).map<CouncilPosition?>((x) => CouncilPosition.fromMap(x as Map<String,dynamic>),),) : null,
      defaultPosition: map['defaultPosition'] != null ? CouncilPosition.fromMap(map['defaultPosition'] as Map<String,dynamic>) : null,
    );
  }





  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.fullName == fullName &&
      other.email == email &&
      other.role == role &&
      other.image == image &&
      listEquals(other.councilPositions, councilPositions) &&
      other.defaultPosition == defaultPosition;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      role.hashCode ^
      image.hashCode ^
      councilPositions.hashCode ^
      defaultPosition.hashCode;
  }
}
