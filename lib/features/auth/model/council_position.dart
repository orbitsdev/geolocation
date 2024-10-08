class CouncilPosition {
  final int? id;
  final String? positionName;

  CouncilPosition({
    this.id,
    this.positionName,
  });

  factory CouncilPosition.fromJson(Map<String, dynamic> json) {
    return CouncilPosition(
      id: json['id'],
      positionName: json['position_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position_name': positionName,
    };
  }
}