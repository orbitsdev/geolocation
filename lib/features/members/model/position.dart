// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Position {

  int? id;
  String name;
  Position({
    this.id,
    required this.name,
  });


  Position copyWith({
    int? id,
    String? name,
  }) {
    return Position(
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

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Position.fromJson(String source) => Position.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Position(id: $id, name: $name)';

  
}
