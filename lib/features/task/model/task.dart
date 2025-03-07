// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/file/model/media_file.dart';

class Task {

    static const String ALL = 'All';
    static const String STATUS_TODO = 'To Do';
    static const String STATUS_IN_PROGRESS = 'In Progress';
    static const String STATUS_COMPLETED = 'Completed';
    static const String STATUS_APPROVE = 'Completed';
    static const String STATUS_NEED_REVISION = 'Needs Revision';
    static const String STATUS_REJECTED = 'Rejected';
    static const String STATUS_RESUBMIT = 'Resubmit';
    


  

  int? id;
  String? title;
  String? taskDetails;
  String? dueDate;
  String? completedAt;
  String? status;
  String? remarks;
  bool? isLock;
  bool? isDone;
  String? statusChangedAt;
  String? createdAt;
  String? updatedAt;
  CouncilPosition? assignedCouncilPosition;
  CouncilPosition? approvedByCouncilPosition;
  List<MediaFile>? media;


  Task({
    this.id,
    this.title,
    this.taskDetails,
    this.dueDate,
    this.completedAt,
    this.status,
    this.remarks,
    this.isLock,
    this.isDone,
    this.statusChangedAt,
    this.createdAt,
    this.updatedAt,
    this.assignedCouncilPosition,
    this.approvedByCouncilPosition,
     this.media,
  });

  Task copyWith({
    int? id,
    String? title,
    String? taskDetails,
    String? dueDate,
    String? completedAt,
    String? status,
    String? remarks,
    bool? isLock,
    bool? isDone,
    String? statusChangedAt,
    String? createdAt,
    String? updatedAt,
  CouncilPosition? assignedCouncilPosition,
  CouncilPosition? approvedByCouncilPosition,
     List<MediaFile>? media,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      taskDetails: taskDetails ?? this.taskDetails,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      isLock: isLock ?? this.isLock,
      isDone: isDone ?? this.isDone,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedCouncilPosition: assignedCouncilPosition ?? this.assignedCouncilPosition,
      approvedByCouncilPosition:approvedByCouncilPosition ??this.approvedByCouncilPosition,
      media:media ?? this.media,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'task_details': taskDetails,
      'due_date': dueDate,
      'completed_at': completedAt,
      'status': status,
      'remarks': remarks,
      'isLock': isLock,
      'isDone': isDone,
      'statusChangedAt': statusChangedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'assigned_council_position': assignedCouncilPosition?.toMap(),
      'approved_by_council_position': approvedByCouncilPosition?.toMap(),
       'media': media != null ? media?.map((x) => x.toMap()).toList() : [],
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      taskDetails: map['task_details'] != null ? map['task_details'] as String : null,
      dueDate: map['due_date'] != null ? map['due_date'] as String : null,
      completedAt: map['completed_at'] != null ? map['completed_at'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      isLock: map['isLock'] != null ? map['isLock'] as bool : null,
      isDone: map['isDone'] != null ? map['isDone'] as bool : null,
      statusChangedAt: map['status_changed_at'] != null ? map['status_changed_at'] as String : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      assignedCouncilPosition: map['assigned_council_position']!= null ?  CouncilPosition.fromMap(map['assigned_council_position']) : null,
      approvedByCouncilPosition: map['approved_by_council_position']!= null ?  CouncilPosition.fromMap(map['approved_by_council_position']) : null,
      media: map['media'] != null
          ? List<MediaFile>.from(
              (map['media'] as List<dynamic>).map<MediaFile?>(
                (x) => MediaFile.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, taskDetails: $taskDetails, dueDate: $dueDate, completedAt: $completedAt, status: $status, remarks: $remarks, isLock: $isLock, isDone: $isDone,  statusChangedAt: $statusChangedAt,createdAt: $createdAt, updatedAt: $updatedAt,  assignedCouncilPosition: $assignedCouncilPosition,  approvedByCouncilPosition: $approvedByCouncilPosition,  media: $media)';
  }


  isCompleted(int officerId){
    return status == Task.STATUS_COMPLETED;
  }
  
  bool isTaskNotCompleteAndAssignedToCurrentOfficer() {
  int? officerId = AuthController.controller.user.value.defaultPosition?.id;
  return (status != Task.STATUS_COMPLETED && assignedCouncilPosition?.id == officerId);
}
  
  bool ifNeedRevisionOrRejected() {
  return ((status == Task.STATUS_NEED_REVISION || status == Task.STATUS_REJECTED) && remarks != null);
}


  String taskAndOfficer() {
      int? officerId = AuthController.controller.user.value.defaultPosition?.id;

  return 'STATUS: ${status} - OFFICER: ${assignedCouncilPosition?.id} - LOGIN OFFICER: ${officerId}';
}

//owner
bool isTaskOwner() {
  int? officerId = AuthController.controller.user.value.defaultPosition?.id;
  return (assignedCouncilPosition?.id == officerId);
 
}

}


 