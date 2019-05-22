import 'package:meta/meta.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/request_response.dart';

abstract class PublicationDataSource {
  //-------Publication-------
  Future<RequestResponse<PublicationEntity>> publish(
      PublicationEntity publication);

  Future<RequestResponse<PublicationEntity>> updatePublication(
      PublicationEntity publication);

  Future<RequestResponse<PublicationEntity>> deletePublication(
      PublicationEntity publication);

  Future<RequestResponse<FollowEntity>> followPublication(FollowEntity follow);

  //-------React in Publication-------
  Future<RequestResponse<ReactEntity>> reactInPublication(ReactEntity react);

  Future<RequestResponse<ReactEntity>> unReactInPublication(
      String publicationId, String userId);

  //-------Reply to Publication-------
  Future<RequestResponse<ReplyEntity>> replyToPublication(ReplyEntity reply);

  Future<RequestResponse<ReplyEntity>> updateReplyToPublication(
      ReplyEntity reply);

  Future<RequestResponse<ReplyEntity>> removeReplyToPublication(
      ReplyEntity reply);

  //-------React in Reply-------
  Future<RequestResponse<ReactEntity>> reactInReply(ReactEntity react);

  Future<RequestResponse<ReactEntity>> unReactInReply(
      String reactId, String userId);

  //-------Feed-------
  Future<RequestResponse<List<PublicationEntity>>> feed({
    @required int page,
    @required int itemsPerPage,
  });

  //-------Publication that I followed-------
  Future<RequestResponse<List<PublicationEntity>>> publicationsFollowed(
    String userId, {
    @required int page,
    @required int itemPerPage,
  });

  //-------My Publication-------
  Future<RequestResponse<List<PublicationEntity>>> myPublications(
    String userId, {
    @required int page,
    @required int itemPerPage,
  });
}
