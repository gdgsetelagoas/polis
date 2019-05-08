class ReactEntity {
  String publicationId;
  String replyId;
  String userId;
  String createdAt;
  String type;

  ReactEntity(
      {this.publicationId,
      this.replyId,
      this.userId,
      this.createdAt,
      this.type});

  ReactEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    replyId = json['reply_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['reply_id'] = this.replyId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    return data..removeWhere((_, value) => value == null);
  }
}
