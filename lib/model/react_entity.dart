class ReactEntity {
  String publicationId;
  String replyId;
  String userId;
  String createdAt;
  ReactType type;
  String reactId;

  ReactEntity(
      {this.publicationId,
      this.replyId,
      this.userId,
      this.reactId,
      this.createdAt,
      this.type = ReactType.LIKE});

  ReactEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    replyId = json['reply_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    type = ReactType.values.firstWhere(
        (react) => react.toString() == json['type'],
        orElse: () => ReactType.LIKE);
    reactId = json['react_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['reply_id'] = this.replyId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['type'] = this.type.toString();
    data['react_id'] = this.reactId;
    return data..removeWhere((_, value) => value == null);
  }

  String get name => const <ReactType, String>{
        ReactType.LIKE: "Gostei",
        ReactType.INDIGNANT: "Indignado",
        ReactType.ASTONISHED: "Surpreendido",
        ReactType.SUPPORT: "Apoio",
        ReactType.ANGRY: "Raiva"
      }[type];

  String get symbol => const <ReactType, String>{
        ReactType.LIKE: "👍🏼",
        ReactType.INDIGNANT: "😖",
        ReactType.ASTONISHED: "😲",
        ReactType.SUPPORT: "🤞🏼",
        ReactType.ANGRY: "😤"
      }[type];
}

enum ReactType { LIKE, INDIGNANT, ASTONISHED, SUPPORT, ANGRY }
