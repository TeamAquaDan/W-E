class MissionModel {
  final int missionId;
  final String missionName;
  final int missionReward;
  final String deadlineDate;
  final int status;
  final String userName;

  MissionModel({
    required this.missionId,
    required this.missionName,
    required this.missionReward,
    required this.deadlineDate,
    required this.status,
    required this.userName,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      missionId: json['mission_id'] ?? 0,
      missionName: json['mission_name'] ?? '',
      missionReward: json['mission_reward'] ?? 0,
      deadlineDate: json['deadline_date'] ?? '',
      status: json['status'] ?? 0,
      userName: json['user_name'] ?? '',
    );
  }
}
