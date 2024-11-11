// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notification {
  String? id;
  int? notifiable_id;
  String? read_at;
  String? created_at;
  NotificationMessage? data;
  Notification({
    this.id,
    this.notifiable_id,
    this.read_at,
    this.created_at,
    this.data,
  });



  Notification copyWith({
    String? id,
    int? notifiable_id,
    String? read_at,
    String? created_at,
     NotificationMessage? data,
  }) {
    return Notification(
      id: id ?? this.id,
      notifiable_id: notifiable_id ?? this.notifiable_id,
      read_at: read_at ?? this.read_at,
      created_at: created_at ?? this.created_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notifiable_id': notifiable_id,
      'read_at': read_at,
      'created_at': created_at,
      'data': data?.toMap(),
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] != null ? map['id'] as String : null,
      notifiable_id: map['notifiable_id'] != null ? map['notifiable_id'] as int : null,
      read_at: map['read_at'] != null ? map['read_at'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
       data: map['data'] != null ? NotificationMessage.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) => Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Notification(id: $id, notifiable_id: $notifiable_id, read_at: $read_at, created_at: $created_at data: $data)';

  
}

class NotificationMessage {

  int? model_id;
  String? title;
  String? message;
  NotificationMessage({
    this.model_id,
    this.title,
    this.message,
  });
  


  NotificationMessage copyWith({
    int? model_id,
    String? title,
    String? message,
  }) {
    return NotificationMessage(
      model_id: model_id ?? this.model_id,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model_id': model_id,
      'title': title,
      'message': message,
    };
  }

  factory NotificationMessage.fromMap(Map<String, dynamic> map) {
    return NotificationMessage(
      model_id: map['model_id'] != null ? map['model_id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessage.fromJson(String source) => NotificationMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationMessage(model_id: $model_id, title: $title, message: $message)';

  @override
  bool operator ==(covariant NotificationMessage other) {
    if (identical(this, other)) return true;
  
    return 
      other.model_id == model_id &&
      other.title == title &&
      other.message == message;
  }

  @override
  int get hashCode => model_id.hashCode ^ title.hashCode ^ message.hashCode;
}
