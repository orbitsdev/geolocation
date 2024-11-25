// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/event/model/event.dart';


class RelatedModel {
  String? type; // Model type (e.g., "Event", "Collection")
  int? id; // Model ID
  dynamic data; // Model-specific data (Event or Collection)

  RelatedModel({
    this.type,
    this.id,
    this.data,
  });

  factory RelatedModel.fromMap(Map<String, dynamic> map) {
    return RelatedModel(
      type: map['type'],
      id: map['id'],
      data: map['type'] == 'Event'
          ? Event.fromMap(map['data']) // Deserialize to Event
          : map['type'] == 'Collection'
              ? Collection.fromMap(map['data']) // Deserialize to Collection
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'id': id,
      'data': data?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory RelatedModel.fromJson(String source) =>
      RelatedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RelatedModel(type: $type, id: $id, data: $data)';
}
