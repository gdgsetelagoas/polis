class ReplyEntity {
  String publicationId;
  String updatedAt;
  String userId;
  bool edited;
  int numReacts;
  String createdAt;
  List<ReplyResource> resources;
  String body;

  ReplyEntity(
      {this.publicationId,
      this.updatedAt,
      this.userId,
      this.edited,
      this.numReacts,
      this.createdAt,
      this.resources,
      this.body});

  ReplyEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    edited = json['edited'];
    numReacts = json['num_reacts'];
    createdAt = json['created_at'];
    if (json['resources'] != null) {
      resources = new List<ReplyResource>();
      (json['resources'] as List).forEach((v) {
        resources.add(new ReplyResource.fromJson(v));
      });
    }
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['edited'] = this.edited;
    data['num_reacts'] = this.numReacts;
    data['created_at'] = this.createdAt;
    if (this.resources != null) {
      data['resources'] = this.resources.map((v) => v.toJson()).toList();
    }
    data['body'] = this.body;
    return data..removeWhere((_, value) => value == null);
  }
}

class ReplyResource {
  String resource;
  String type;

  ReplyResource({this.resource, this.type});

  ReplyResource.fromJson(Map<String, dynamic> json) {
    resource = json['resource'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource'] = this.resource;
    data['type'] = this.type;
    return data;
  }
}
