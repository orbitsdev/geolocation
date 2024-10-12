// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocation/features/auth/model/council_position.dart';

class Council {
  final int? id;
  final String? name;
  final bool? isActive;
  final List<CouncilPosition>? councilPositions;
  final String? createdAt;  // Use String instead of DateTime
  final String? updatedAt;  // Use String instead of DateTime

  Council({
    this.id,
    this.name,
    this.isActive,
    this.councilPositions,
    this.createdAt,
    this.updatedAt,
  });

  Council copyWith({
    int? id,
    String? name,
    bool? isActive,
    List<CouncilPosition>? councilPositions,
    String? createdAt,
    String? updatedAt,
  }) {
    return Council(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      councilPositions: councilPositions ?? this.councilPositions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'is_active': isActive,
      'council_positions': councilPositions?.map((e) => e.toMap()).toList(),
      'created_at': createdAt,  // Keep as String
      'updated_at': updatedAt,  // Keep as String
    };
  }

  factory Council.fromMap(Map<String, dynamic> map) {
    return Council(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      isActive: map['is_active'] != null ? map['is_active'] as bool : null,
      councilPositions: map['council_positions'] != null
          ? List<CouncilPosition>.from(map['council_positions'].map((x) => CouncilPosition.fromMap(x)))
          : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,  // Keep as String
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,  // Keep as String
    );
  }

  String toJson() => json.encode(toMap());

  factory Council.fromJson(String source) => Council.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Council(id: $id, name: $name, isActive: $isActive, councilPositions: $councilPositions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Council other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.isActive == isActive &&
        listEquals(other.councilPositions, councilPositions) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isActive.hashCode ^
        councilPositions.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
