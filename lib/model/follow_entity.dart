class FollowEntity {
  String publicationId;
  String userId;
  String createdAt;
  String followId;

  FollowEntity({this.publicationId, this.userId, this.createdAt});

  FollowEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    followId = json['follow_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['follow_id'] = this.followId;
    return data..removeWhere((_, value) => value == null);
  }
}
