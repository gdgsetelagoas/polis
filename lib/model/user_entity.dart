class UserEntity {
  String password;
  String updatedAt;
  String userId;
  String name;
  String cpf;
  String photo;
  String createdAt;
  String email;
  int numPublications;
  int numFollows;
  int numReactions;
  int numFollowers;

  UserEntity(
      {this.password,
      this.updatedAt,
      this.userId,
      this.name,
      this.cpf,
      this.photo,
      this.createdAt,
      this.email,
      this.numPublications = 0,
      this.numFollows = 0,
      this.numReactions = 0,
      this.numFollowers = 0});

  UserEntity.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    name = json['name'];
    cpf = json['cpf'];
    photo = json['photo'];
    createdAt = json['created_at'];
    email = json['email'];
    numPublications = json['num_publications'];
    numFollows = json['num_follows'];
    numReactions = json['num_reactions'];
    numFollowers = json['num_followers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['cpf'] = this.cpf;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['email'] = this.email;
    data['num_publications'] = this.numPublications;
    data['num_follows'] = this.numFollows;
    data['num_reactions'] = this.numReactions;
    data['num_followers'] = this.numFollowers;
    return data..removeWhere((_, value) => value == null);
  }
}
