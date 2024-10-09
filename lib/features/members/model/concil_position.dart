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
}
