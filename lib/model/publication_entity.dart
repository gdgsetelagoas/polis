class PublicationEntity {
  String publicationId;
  int numViews;
  String updatedAt;
  String userId;
  bool edited;
  String subtitle;
  String createdAt;
  List<PublicationResource> resources;
  bool checked;
  int numReplies;
  int numReacts;
  String status;

  PublicationEntity(
      {this.publicationId,
      this.numViews,
      this.updatedAt,
      this.userId,
      this.edited,
      this.subtitle,
      this.createdAt,
      this.resources,
      this.checked,
      this.numReplies,
      this.numReacts,
      this.status});

  PublicationEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    numViews = json['num_views'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    edited = json['edited'];
    subtitle = json['subtitle'];
    createdAt = json['created_at'];
    if (json['resources'] != null) {
      resources = new List<PublicationResource>();
      (json['resources'] as List).forEach((v) {
        resources.add(new PublicationResource.fromJson(v));
      });
    }
    checked = json['checked'];
    numReplies = json['num_replies'];
    numReacts = json['num_reacts'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['num_views'] = this.numViews;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['edited'] = this.edited;
    data['subtitle'] = this.subtitle;
    data['created_at'] = this.createdAt;
    if (this.resources != null) {
      data['resources'] = this.resources.map((v) => v.toJson()).toList();
    }
    data['checked'] = this.checked;
    data['num_replies'] = this.numReplies;
    data['num_reacts'] = this.numReacts;
    data['status'] = this.status;
    return data;
  }
}

class PublicationResource {
  String resource;
  String type;

  PublicationResource({this.resource, this.type});

  PublicationResource.fromJson(Map<String, dynamic> json) {
    resource = json['resource'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource'] = this.resource;
    data['type'] = this.type;
    return data..removeWhere((_, value) => value == null);
  }
}
