// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
String? id;
  int? notifiable_id;
  String? read_at;
  String? created_at;
  NotificationModel({
    this.id,
    this.notifiable_id,
    this.read_at,
    this.created_at,
  });


  NotificationModel copyWith({
    String? id,
    int? notifiable_id,
    String? read_at,
    String? created_at,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notifiable_id: notifiable_id ?? this.notifiable_id,
      read_at: read_at ?? this.read_at,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notifiable_id': notifiable_id,
      'read_at': read_at,
      'created_at': created_at,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as String : null,
      notifiable_id: map['notifiable_id'] != null ? map['notifiable_id'] as int : null,
      read_at: map['read_at'] != null ? map['read_at'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, notifiable_id: $notifiable_id, read_at: $read_at, created_at: $created_at)';
  }

}
