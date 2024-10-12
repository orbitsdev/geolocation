class CouncilPosition {
  final int? id;
  final int? councilId;
  final String? councilName;
  final int? userId;
  final String? fullName;
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
    this.fullName,
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
      fullName: json['fullname'],
      image: json['image'],
      position: json['position'],
      isLogin: json['is_login'],
      grantAccess: json['grant_access'],
      totalToDoTasks: json['total_to_do_tasks'],
      totalInProgressTasks: json['total_in_progress_tasks'],
      totalCompletedTasks: json['total_completed_tasks'],
      totalCompletedLateTasks: json['total_completed_late_tasks'],
      totalDueTasks: json['total_due_tasks'],
      totalOnHoldTasks: json['total_on_hold_tasks'],
      totalCancelledTasks: json['total_cancelled_tasks'],
      totalReviewTasks: json['total_review_tasks'],
      totalBlockedTasks: json['total_blocked_tasks'],
    );
  }

  // Convert CouncilPosition object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'council_id': councilId,
      'council_name': councilName,
      'user_id': userId,
      'fullname': fullName,
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

  // Convert CouncilPosition object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'council_id': councilId,
      'council_name': councilName,
      'user_id': userId,
      'fullname': fullName,
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

  // Create CouncilPosition from Map
  factory CouncilPosition.fromMap(Map<String, dynamic> map) {
    return CouncilPosition(
      id: map['id'] != null ? map['id'] as int : null,
      councilId: map['council_id'] != null ? map['council_id'] as int : null,
      councilName: map['council_name'] != null ? map['council_name'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      fullName: map['fullname'] != null ? map['fullname'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      isLogin: map['is_login'] != null ? map['is_login'] as bool : null,
      grantAccess: map['grant_access'] != null ? map['grant_access'] as bool : null,
      totalToDoTasks: map['total_to_do_tasks'] != null ? map['total_to_do_tasks'] as int : null,
      totalInProgressTasks: map['total_in_progress_tasks'] != null ? map['total_in_progress_tasks'] as int : null,
      totalCompletedTasks: map['total_completed_tasks'] != null ? map['total_completed_tasks'] as int : null,
      totalCompletedLateTasks: map['total_completed_late_tasks'] != null ? map['total_completed_late_tasks'] as int : null,
      totalDueTasks: map['total_due_tasks'] != null ? map['total_due_tasks'] as int : null,
      totalOnHoldTasks: map['total_on_hold_tasks'] != null ? map['total_on_hold_tasks'] as int : null,
      totalCancelledTasks: map['total_cancelled_tasks'] != null ? map['total_cancelled_tasks'] as int : null,
      totalReviewTasks: map['total_review_tasks'] != null ? map['total_review_tasks'] as int : null,
      totalBlockedTasks: map['total_blocked_tasks'] != null ? map['total_blocked_tasks'] as int : null,
    );
  }

  // Helper method for copying the object with new values
  CouncilPosition copyWith({
    int? id,
    int? councilId,
    String? councilName,
    int? userId,
    String? fullName,
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
      fullName: fullName ?? this.fullName,
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

  @override
  String toString() {
    return 'CouncilPosition(id: $id, councilId: $councilId, councilName: $councilName, userId: $userId, fullName: $fullName, image: $image, position: $position, isLogin: $isLogin, grantAccess: $grantAccess, totalToDoTasks: $totalToDoTasks, totalInProgressTasks: $totalInProgressTasks, totalCompletedTasks: $totalCompletedTasks, totalCompletedLateTasks: $totalCompletedLateTasks, totalDueTasks: $totalDueTasks, totalOnHoldTasks: $totalOnHoldTasks, totalCancelledTasks: $totalCancelledTasks, totalReviewTasks: $totalReviewTasks, totalBlockedTasks: $totalBlockedTasks)';
  }

  @override
  bool operator ==(covariant CouncilPosition other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.councilId == councilId &&
        other.councilName == councilName &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.image == image &&
        other.position == position &&
        other.isLogin == isLogin &&
        other.grantAccess == grantAccess &&
        other.totalToDoTasks == totalToDoTasks &&
        other.totalInProgressTasks == totalInProgressTasks &&
        other.totalCompletedTasks == totalCompletedTasks &&
        other.totalCompletedLateTasks == totalCompletedLateTasks &&
        other.totalDueTasks == totalDueTasks &&
        other.totalOnHoldTasks == totalOnHoldTasks &&
        other.totalCancelledTasks == totalCancelledTasks &&
        other.totalReviewTasks == totalReviewTasks &&
        other.totalBlockedTasks == totalBlockedTasks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        councilId.hashCode ^
        councilName.hashCode ^
        userId.hashCode ^
        fullName.hashCode ^
        image.hashCode ^
        position.hashCode ^
        isLogin.hashCode ^
        grantAccess.hashCode ^
        totalToDoTasks.hashCode ^
        totalInProgressTasks.hashCode ^
        totalCompletedTasks.hashCode ^
        totalCompletedLateTasks.hashCode ^
        totalDueTasks.hashCode ^
        totalOnHoldTasks.hashCode ^
        totalCancelledTasks.hashCode ^
        totalReviewTasks.hashCode ^
        totalBlockedTasks.hashCode;
  }
}
