// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CouncilPosition {

  int? id;
  String name;
  CouncilPosition({
    this.id,
    required this.name,
  });


  CouncilPosition copyWith({
    int? id,
    String? name,
  }) {
    return CouncilPosition(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory CouncilPosition.fromMap(Map<String, dynamic> map) {
    return CouncilPosition(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouncilPosition.fromJson(String source) => CouncilPosition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CouncilPosition(id: $id, name: $name)';

  
}
