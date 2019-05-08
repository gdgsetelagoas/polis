import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "FollowEntity") {
      return FollowEntity.fromJson(json) as T;
    } else if (T.toString() == "PublicationEntity") {
      return PublicationEntity.fromJson(json) as T;
    } else if (T.toString() == "ReactEntity") {
      return ReactEntity.fromJson(json) as T;
    } else if (T.toString() == "ReplyEntity") {
      return ReplyEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}