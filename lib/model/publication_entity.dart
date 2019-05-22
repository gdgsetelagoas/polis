class PublicationEntity {
  String publicationId;
  int numViews;
  DateTime updatedAt;
  String userId;
  bool edited;
  String subtitle;
  DateTime createdAt;
  List<PublicationResource> resources;
  bool checked;
  int numReplies;
  int numReacts;
  int numFollowers;
  String status;

  PublicationEntity(
      {this.publicationId,
      this.numViews = 0,
      this.updatedAt,
      this.userId,
      this.edited = false,
      this.subtitle,
      this.createdAt,
      this.resources,
      this.checked = false,
      this.numReplies = 0,
      this.numReacts = 0,
      this.numFollowers = 0,
      this.status});

  PublicationEntity.fromJson(Map<String, dynamic> json) {
    publicationId = json['publication_id'];
    numViews = json['num_views'];
    updatedAt = DateTime.tryParse(json['updated_at']);
    userId = json['user_id'];
    edited = json['edited'];
    subtitle = json['subtitle'];
    createdAt = DateTime.tryParse(json['created_at']);
    if (json['resources'] != null) {
      resources = new List<PublicationResource>();
      (json['resources'] as List).forEach((v) {
        resources.add(new PublicationResource.fromJson(v));
      });
    }
    checked = json['checked'];
    numReplies = json['num_replies'];
    numReacts = json['num_reacts'];
    numFollowers = json['num_followers'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publication_id'] = this.publicationId;
    data['num_views'] = this.numViews;
    data['updated_at'] = this.updatedAt.toIso8601String();
    data['user_id'] = this.userId;
    data['edited'] = this.edited;
    data['subtitle'] = this.subtitle;
    data['created_at'] = this.createdAt.toIso8601String();
    if (this.resources != null) {
      data['resources'] = this.resources.map((v) => v.toJson()).toList();
    }
    data['checked'] = this.checked;
    data['num_replies'] = this.numReplies;
    data['num_reacts'] = this.numReacts;
    data['num_followers'] = this.numFollowers;
    data['status'] = this.status;
    return data..removeWhere((_, value) => value == null);
  }
}

class PublicationResource {
  String source;
  PublicationResourceType type;

  PublicationResource({this.source, this.type});

  PublicationResource.fromJson(Map<dynamic, dynamic> json) {
    source = json['resource'];
    type = PublicationResourceType.values
        .firstWhere((e) => e.toString() == json['type'], orElse: () => null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource'] = this.source;
    data['type'] = this.type.toString();
    return data..removeWhere((_, value) => value == null);
  }
}

enum PublicationResourceType { IMAGE, VIDEO }
