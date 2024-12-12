// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/councils/model/council.dart';


class Event {
  int? id;
  String? title;
  String? description;
  String? content;
  num? latitude;
  num? longitude;
  num? radius;
  String? specifiedLocation;
  String? mapLocation;
  String? placeId;
  bool? isPublish;
  String? startTime;
  String? endTime;
  String? dateOnly;
  String? startTimeOnly;
  String? endTimeOnly;
  String? date;
  bool? isActive;
  bool? restrictEvent;
  int? maxCapacity;
  String? type;
  String? createdAt;
  String? updatedAt;
  Council? council;
  CouncilPosition? councilPosition;
  int? total_attendance;

  Event({
    this.id,
    this.title,
    this.description,
    this.content,
    this.latitude,
    this.longitude,
    this.radius,
    this.specifiedLocation,
    this.mapLocation,
    this.placeId,
     this.isPublish,
    this.startTime,
    this.endTime,
    this.dateOnly,
    this.startTimeOnly,
    this.endTimeOnly,
    this.isActive,
    this.restrictEvent,
    this.maxCapacity,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.council,
    this.councilPosition,
    this.total_attendance,
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? content,
    num? latitude,
    num? longitude,
    num? radius,
    String? specifiedLocation,
    String? mapLocation,
    String? placeId,
        bool? isPublish,
    String? startTime,
    String? endTime,
   String? dateOnly,
  String? startTimeOnly,
  String? endTimeOnly,
    bool? isActive,
    bool? restrictEvent,
    int? maxCapacity,
    String? type,
    String? createdAt,
    String? updatedAt,
    Council? council,
    CouncilPosition? councilPosition,
    int? total_attendance,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      specifiedLocation: specifiedLocation ?? this.specifiedLocation,
      mapLocation: mapLocation ?? this.mapLocation,
      placeId: placeId ?? this.placeId,
           isPublish: isPublish ?? this.isPublish,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dateOnly: dateOnly ?? this.dateOnly,
      startTimeOnly: startTimeOnly ?? this.startTimeOnly,
      endTimeOnly: endTimeOnly ?? this.endTimeOnly,
      isActive: isActive ?? this.isActive,
      restrictEvent: restrictEvent ?? this.restrictEvent,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      council: council ?? this.council,
      councilPosition: councilPosition ?? this.councilPosition,
      total_attendance: total_attendance ?? this.total_attendance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'specified_location': specifiedLocation,
      'map_location': mapLocation,
      'place_id': placeId,
         'is_publish': isPublish,
      'start_time': startTime,
      'end_time': endTime,
      'date': dateOnly,
      'start_time_only': startTimeOnly,
      'end_time_only': endTimeOnly,
      'is_active': isActive,
      'restrict_event': restrictEvent,
      'max_capacity': maxCapacity,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'council': council?.toMap(),
      'council_position': councilPosition?.toMap(),
      'total_attendance': total_attendance,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as num : null,
      longitude: map['longitude'] != null ? map['longitude'] as num : null,
      radius: map['radius'] != null ? map['radius'] as num : null,
      specifiedLocation: map['specified_location'] != null ? map['specified_location'] as String : null,
      mapLocation: map['map_location'] != null ? map['map_location'] as String : null,
      placeId: map['place_id'] != null ? map['place_id'] as String : null,
            isPublish: map['is_publish'] != null ? map['is_publish'] as bool : null,
      startTime: map['start_time'] != null ? map['start_time'] as String : null,
      endTime: map['end_time'] != null ? map['end_time'] as String : null,
      dateOnly: map['date'] != null ? map['date'] as String : null,
      startTimeOnly: map['start_time_only'] != null ? map['start_time_only'] as String : null,
      endTimeOnly: map['end_time_only'] != null ? map['end_time_only'] as String : null,
      isActive: map['is_active'] != null ? map['is_active'] as bool : null,
      restrictEvent: map['restrict_event'] != null ? map['restrict_event'] as bool : null,
      maxCapacity: map['max_capacity'] != null ? map['max_capacity'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      council: map['council'] != null ? Council.fromMap(map['council']) : null,
      councilPosition: map['council_position'] != null ? CouncilPosition.fromMap(map['council_position']) : null,
       total_attendance: map['total_attendance'] != null ? map['total_attendance'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, content: $content, latitude: $latitude, longitude: $longitude, radius: $radius, specifiedLocation: $specifiedLocation, mapLocation: $mapLocation, placeId: $placeId, isPublish: $isPublish, startTime: $startTime, endTime: $endTime, isActive: $isActive, restrictEvent: $restrictEvent, maxCapacity: $maxCapacity, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, council: $council, councilPosition: $councilPosition, total_attendance: $total_attendance)';
  }
}
