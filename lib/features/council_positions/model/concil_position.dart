// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
class CouncilPosition {
  final int? id;
  final int? councilId;
  final String? councilName;
  final int? userId;
  final String? fullname;
  final String? image;
  final String? position;
  final bool? isLogin;
  final bool? grantAccess;
  final int? totalToDoTasks;
  final int? totalInProgressTasks;
  final int? totalCompletedTasks;
  final int? totalCompletedLateTasks;
  final int? totalDueTasks;
  final int? totalOnHoldTasks;
  final int? totalCancelledTasks;
  final int? totalReviewTasks;
  final int? totalBlockedTasks;

  CouncilPosition({
    this.id,
    this.councilId,
    this.councilName,
    this.userId,
    this.fullname,
    this.image,
    this.position,
    this.isLogin,
    this.grantAccess,
    this.totalToDoTasks,
    this.totalInProgressTasks,
    this.totalCompletedTasks,
    this.totalCompletedLateTasks,
    this.totalDueTasks,
    this.totalOnHoldTasks,
    this.totalCancelledTasks,
    this.totalReviewTasks,
    this.totalBlockedTasks,
  });

  // Factory constructor to create a CouncilPosition from a JSON object
  factory CouncilPosition.fromJson(Map<String, dynamic> json) {
    return CouncilPosition(
      id: json['id'],
      councilId: json['council_id'],
      councilName: json['council_name'],
      userId: json['user_id'],
      fullname: json['fullname'],
      image: json['image'],
      position: json['position'],
      isLogin: json['is_login'],
      grantAccess: json['grant_access'] ?? false,
      totalToDoTasks: json['total_to_do_tasks'] ?? 0,
      totalInProgressTasks: json['total_in_progress_tasks'] ?? 0,
      totalCompletedTasks: json['total_completed_tasks'] ?? 0,
      totalCompletedLateTasks: json['total_completed_late_tasks'] ?? 0,
      totalDueTasks: json['total_due_tasks'] ?? 0,
      totalOnHoldTasks: json['total_on_hold_tasks'] ?? 0,
      totalCancelledTasks: json['total_cancelled_tasks'] ?? 0,
      totalReviewTasks: json['total_review_tasks'] ?? 0,
      totalBlockedTasks: json['total_blocked_tasks'] ?? 0,
    );
  }

  // Convert CouncilPosition object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'council_id': councilId,
      'council_name': councilName,
      'user_id': userId,
      'fullname': fullname,
      'image': image,
      'position': position,
      'is_login': isLogin,
      'grant_access': grantAccess,
      'total_to_do_tasks': totalToDoTasks,
      'total_in_progress_tasks': totalInProgressTasks,
      'total_completed_tasks': totalCompletedTasks,
      'total_completed_late_tasks': totalCompletedLateTasks,
      'total_due_tasks': totalDueTasks,
      'total_on_hold_tasks': totalOnHoldTasks,
      'total_cancelled_tasks': totalCancelledTasks,
      'total_review_tasks': totalReviewTasks,
      'total_blocked_tasks': totalBlockedTasks,
    };
  }

  CouncilPosition copyWith({
    int? id,
    int? councilId,
    String? councilName,
    int? userId,
    String? fullname,
    String? image,
    String? position,
    bool? isLogin,
    bool? grantAccess,
    int? totalToDoTasks,
    int? totalInProgressTasks,
    int? totalCompletedTasks,
    int? totalCompletedLateTasks,
    int? totalDueTasks,
    int? totalOnHoldTasks,
    int? totalCancelledTasks,
    int? totalReviewTasks,
    int? totalBlockedTasks,
  }) {
    return CouncilPosition(
      id: id ?? this.id,
      councilId: councilId ?? this.councilId,
      councilName: councilName ?? this.councilName,
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      image: image ?? this.image,
      position: position ?? this.position,
      isLogin: isLogin ?? this.isLogin,
      grantAccess: grantAccess ?? this.grantAccess,
      totalToDoTasks: totalToDoTasks ?? this.totalToDoTasks,
      totalInProgressTasks: totalInProgressTasks ?? this.totalInProgressTasks,
      totalCompletedTasks: totalCompletedTasks ?? this.totalCompletedTasks,
      totalCompletedLateTasks: totalCompletedLateTasks ?? this.totalCompletedLateTasks,
      totalDueTasks: totalDueTasks ?? this.totalDueTasks,
      totalOnHoldTasks: totalOnHoldTasks ?? this.totalOnHoldTasks,
      totalCancelledTasks: totalCancelledTasks ?? this.totalCancelledTasks,
      totalReviewTasks: totalReviewTasks ?? this.totalReviewTasks,
      totalBlockedTasks: totalBlockedTasks ?? this.totalBlockedTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'councilId': councilId,
      'councilName': councilName,
      'userId': userId,
      'fullname': fullname,
      'image': image,
      'position': position,
      'isLogin': isLogin,
      'grantAccess': grantAccess,
      'totalToDoTasks': totalToDoTasks,
      'totalInProgressTasks': totalInProgressTasks,
      'totalCompletedTasks': totalCompletedTasks,
      'totalCompletedLateTasks': totalCompletedLateTasks,
      'totalDueTasks': totalDueTasks,
      'totalOnHoldTasks': totalOnHoldTasks,
      'totalCancelledTasks': totalCancelledTasks,
      'totalReviewTasks': totalReviewTasks,
      'totalBlockedTasks': totalBlockedTasks,
    };
  }

  factory CouncilPosition.fromMap(Map<String, dynamic> map) {
    return CouncilPosition(
      id: map['id'] != null ? map['id'] as int : null,
      councilId: map['councilId'] != null ? map['councilId'] as int : null,
      councilName: map['councilName'] != null ? map['councilName'] as String : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      isLogin: map['isLogin'] != null ? map['isLogin'] as bool : null,
      grantAccess: map['grantAccess'] != null ? map['grantAccess'] as bool : null,
      totalToDoTasks: map['totalToDoTasks'] != null ? map['totalToDoTasks'] as int : null,
      totalInProgressTasks: map['totalInProgressTasks'] != null ? map['totalInProgressTasks'] as int : null,
      totalCompletedTasks: map['totalCompletedTasks'] != null ? map['totalCompletedTasks'] as int : null,
      totalCompletedLateTasks: map['totalCompletedLateTasks'] != null ? map['totalCompletedLateTasks'] as int : null,
      totalDueTasks: map['totalDueTasks'] != null ? map['totalDueTasks'] as int : null,
      totalOnHoldTasks: map['totalOnHoldTasks'] != null ? map['totalOnHoldTasks'] as int : null,
      totalCancelledTasks: map['totalCancelledTasks'] != null ? map['totalCancelledTasks'] as int : null,
      totalReviewTasks: map['totalReviewTasks'] != null ? map['totalReviewTasks'] as int : null,
      totalBlockedTasks: map['totalBlockedTasks'] != null ? map['totalBlockedTasks'] as int : null,
    );
  }

 
  @override
  String toString() {
    return 'CouncilPosition(id: $id, councilId: $councilId, councilName: $councilName, userId: $userId, fullname: $fullname, image: $image, position: $position, isLogin: $isLogin, grantAccess: $grantAccess, totalToDoTasks: $totalToDoTasks, totalInProgressTasks: $totalInProgressTasks, totalCompletedTasks: $totalCompletedTasks, totalCompletedLateTasks: $totalCompletedLateTasks, totalDueTasks: $totalDueTasks, totalOnHoldTasks: $totalOnHoldTasks, totalCancelledTasks: $totalCancelledTasks, totalReviewTasks: $totalReviewTasks, totalBlockedTasks: $totalBlockedTasks)';
  }

}
