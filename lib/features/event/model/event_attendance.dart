import 'dart:convert';

import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/councils/model/council.dart';

class EventAttendance {
  int? id;
  String? title;
  String? description;
  String? content;
  num? latitude;
  num? longitude;
  num? radius;
  String? startTime;
  String? endTime;
  bool? isActive;
  bool? restrictEvent;
  int? maxCapacity;
  String? type;
  String? specifiedLocation;
  String? mapLocation;
  String? placeId;
  Council? council;
  CouncilPosition? councilPosition;
  int? totalAttendance;

  // Attendance details
  AttendanceDetails? attendance;

  EventAttendance({
    this.id,
    this.title,
    this.description,
    this.content,
    this.latitude,
    this.longitude,
    this.radius,
    this.startTime,
    this.endTime,
    this.isActive,
    this.restrictEvent,
    this.maxCapacity,
    this.type,
    this.specifiedLocation,
    this.mapLocation,
    this.placeId,
    this.council,
    this.councilPosition,
    this.totalAttendance,
    this.attendance,
  });

  EventAttendance copyWith({
    int? id,
    String? title,
    String? description,
    String? content,
    num? latitude,
    num? longitude,
    num? radius,
    String? startTime,
    String? endTime,
    bool? isActive,
    bool? restrictEvent,
    int? maxCapacity,
    String? type,
    String? specifiedLocation,
    String? mapLocation,
    String? placeId,
    Council? council,
    CouncilPosition? councilPosition,
    int? totalAttendance,
    AttendanceDetails? attendance,
  }) {
    return EventAttendance(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
      restrictEvent: restrictEvent ?? this.restrictEvent,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      type: type ?? this.type,
      specifiedLocation: specifiedLocation ?? this.specifiedLocation,
      mapLocation: mapLocation ?? this.mapLocation,
      placeId: placeId ?? this.placeId,
      council: council ?? this.council,
      councilPosition: councilPosition ?? this.councilPosition,
      totalAttendance: totalAttendance ?? this.totalAttendance,
      attendance: attendance ?? this.attendance,
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
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'restrict_event': restrictEvent,
      'max_capacity': maxCapacity,
      'type': type,
      'specified_location': specifiedLocation,
      'map_location': mapLocation,
      'place_id': placeId,
      'council': council?.toMap(),
      'council_position': councilPosition?.toMap(),
      'total_attendance': totalAttendance,
      'attendance': attendance?.toMap(),
    };
  }

  factory EventAttendance.fromMap(Map<String, dynamic> map) {
    return EventAttendance(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      content: map['content'] as String?,
      latitude: map['latitude'] as num?,
      longitude: map['longitude'] as num?,
      radius: map['radius'] as num?,
      startTime: map['start_time'] as String?,
      endTime: map['end_time'] as String?,
      isActive: map['is_active'] as bool?,
      restrictEvent: map['restrict_event'] as bool?,
      maxCapacity: map['max_capacity'] as int?,
      type: map['type'] as String?,
      specifiedLocation: map['specified_location'] as String?,
      mapLocation: map['map_location'] as String?,
      placeId: map['place_id'] as String?,
      council: map['council'] != null ? Council.fromMap(map['council']) : null,
      councilPosition: map['council_position'] != null
          ? CouncilPosition.fromMap(map['council_position'])
          : null,
      totalAttendance: map['total_attendance'] as int?,
      attendance: map['attendance'] != null
          ? AttendanceDetails.fromMap(map['attendance'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventAttendance.fromJson(String source) =>
      EventAttendance.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AttendanceDetails {
  String? checkInTime;
  String? checkOutTime;
  Coordinates? checkInCoordinates;
  Coordinates? checkOutCoordinates;
  String? checkInSelfieUrl;
  String? checkOutSelfieUrl;

  AttendanceDetails({
    this.checkInTime,
    this.checkOutTime,
    this.checkInCoordinates,
    this.checkOutCoordinates,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_coordinates': checkInCoordinates?.toMap(),
      'check_out_coordinates': checkOutCoordinates?.toMap(),
      'check_in_selfie_url': checkInSelfieUrl,
      'check_out_selfie_url': checkOutSelfieUrl,
    };
  }

  factory AttendanceDetails.fromMap(Map<String, dynamic> map) {
    return AttendanceDetails(
      checkInTime: map['check_in_time'] as String?,
      checkOutTime: map['check_out_time'] as String?,
      checkInCoordinates: map['check_in_coordinates'] != null
          ? Coordinates.fromMap(
              map['check_in_coordinates'] as Map<String, dynamic>)
          : null,
      checkOutCoordinates: map['check_out_coordinates'] != null
          ? Coordinates.fromMap(
              map['check_out_coordinates'] as Map<String, dynamic>)
          : null,
      checkInSelfieUrl: map['check_in_selfie_url'] as String?,
      checkOutSelfieUrl: map['check_out_selfie_url'] as String?,
    );
  }
}

class Coordinates {
  final num latitude;
  final num longitude;

  Coordinates({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      latitude: map['latitude'] as num,
      longitude: map['longitude'] as num,
    );
  }
}
