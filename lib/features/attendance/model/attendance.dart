import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/event/model/event.dart';

class Attendance {
  // Fields
  int? id;
  int? eventId;
  int? councilPositionId;
  String? checkInTime;
  String? checkOutTime;
  Map<String, double>? checkInCoordinates;
  Map<String, double>? checkOutCoordinates;
  String? checkInSelfieUrl;
  String? checkOutSelfieUrl;
  String? status;
  String? attendanceTime;
  String? deviceId;
  String? deviceName;
  bool? attendanceAllowed;
  String? notes;
  String? createdAt;
  String? updatedAt;

  // Relationships
  CouncilPosition? councilPosition;
  Event? event;

  // Constructor
  Attendance({
    this.id,
    this.eventId,
    this.councilPositionId,
    this.checkInTime,
    this.checkOutTime,
    this.checkInCoordinates,
    this.checkOutCoordinates,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
    this.status,
    this.attendanceTime,
    this.deviceId,
    this.deviceName,
    this.attendanceAllowed,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.councilPosition,
    this.event,
  });

  // Factory for JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int?,
      eventId: json['event_id'] as int?,
      councilPositionId: json['council_position_id'] as int?,
      checkInTime: json['check_in_time'] as String,
      checkOutTime: json['check_out_time'] as String?,
      checkInCoordinates: json['check_in_coordinates'] != null
          ? {
              'latitude': (json['check_in_coordinates']['latitude'] as num).toDouble(),
              'longitude': (json['check_in_coordinates']['longitude'] as num).toDouble(),
            }
          : null,
      checkOutCoordinates: json['check_out_coordinates'] != null
          ? {
              'latitude': (json['check_out_coordinates']['latitude'] as num).toDouble(),
              'longitude': (json['check_out_coordinates']['longitude'] as num).toDouble(),
            }
          : null,
      checkInSelfieUrl: json['check_in_selfie_url'] as String?,
      checkOutSelfieUrl: json['check_out_selfie_url'] as String?,
      status: json['status'] as String?,
      attendanceTime: json['attendance_time'] as String?,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
      attendanceAllowed: json['attendance_allowed'] ?? false,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      councilPosition: json['council_position'] != null
          ? CouncilPosition.fromJson(json['council_position'])
          : null,
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'council_position_id': councilPositionId,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_coordinates': checkInCoordinates,
      'check_out_coordinates': checkOutCoordinates,
      'check_in_selfie_url': checkInSelfieUrl,
      'check_out_selfie_url': checkOutSelfieUrl,
      'status': status,
      'attendance_time': attendanceTime,
      'device_id': deviceId,
      'device_name': deviceName,
      'attendance_allowed': attendanceAllowed,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'council_position': councilPosition?.toJson(),
      'event': event?.toJson(),
    };
  }

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'councilPositionId': councilPositionId,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'checkInCoordinates': checkInCoordinates,
      'checkOutCoordinates': checkOutCoordinates,
      'checkInSelfieUrl': checkInSelfieUrl,
      'checkOutSelfieUrl': checkOutSelfieUrl,
      'status': status,
      'attendanceTime': attendanceTime,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'attendanceAllowed': attendanceAllowed,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'councilPosition': councilPosition?.toMap(),
      'event': event?.toMap(),
    };
  }

  // Copy with updated fields
  Attendance copyWith({
    int? id,
    int? eventId,
    int? councilPositionId,
    String? checkInTime,
    String? checkOutTime,
    Map<String, double>? checkInCoordinates,
    Map<String, double>? checkOutCoordinates,
    String? checkInSelfieUrl,
    String? checkOutSelfieUrl,
    String? status,
    String? attendanceTime,
    String? deviceId,
    String? deviceName,
    bool? attendanceAllowed,
    String? notes,
    String? createdAt,
    String? updatedAt,
    CouncilPosition? councilPosition,
    Event? event,
  }) {
    return Attendance(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      councilPositionId: councilPositionId ?? this.councilPositionId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInCoordinates: checkInCoordinates ?? this.checkInCoordinates,
      checkOutCoordinates: checkOutCoordinates ?? this.checkOutCoordinates,
      checkInSelfieUrl: checkInSelfieUrl ?? this.checkInSelfieUrl,
      checkOutSelfieUrl: checkOutSelfieUrl ?? this.checkOutSelfieUrl,
      status: status ?? this.status,
      attendanceTime: attendanceTime ?? this.attendanceTime,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      attendanceAllowed: attendanceAllowed ?? this.attendanceAllowed,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      councilPosition: councilPosition ?? this.councilPosition,
      event: event ?? this.event,
    );
  }

  // Debugging output
  @override
  String toString() {
    return 'Attendance(id: $id, eventId: $eventId, checkInTime: $checkInTime, ...)';
  }
}
