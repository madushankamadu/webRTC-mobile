class MeetingUser {
  String? id;
  String? hostId;
  String? hostName;

  MeetingUser({this.id, this.hostId, this.hostName});

  factory MeetingUser.fromJson(dynamic json) {
    return MeetingUser(
      id: json["id"],
      hostId: json["meetingId"],
      hostName: json["hostName"],
    );
  }
}