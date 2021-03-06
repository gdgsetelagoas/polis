import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import 'package:res_publica/data/util/errors.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/request_response.dart';

class FirebasePublicationDataSource extends PublicationDataSource {
  final Firestore firestore;
  final FirebaseStorage firebaseStorage;
  final AccountDataSource accountDataSource;

  static final String _publicationsPath = "publications";
  static final String _repliesPath = "replies";
  static final String _reactsPath = "reacts";
  static final String _followersPath = "followers";

  final StorageReference _publicationStore;
  final StorageReference _replyStore;

  final CollectionReference _reactCollection;
  final CollectionReference _publicationCollection;
  final CollectionReference _replyCollection;
  final CollectionReference _followCollection;

  Query _nextFeedQuery;
  Query _olderFeedQuery;
  Map<String, Query> _olderReplyQueryMap = {};
  Map<String, Query> _nextReplyQueryMap = {};

  FirebasePublicationDataSource({
    @required this.firestore,
    @required this.firebaseStorage,
    @required this.accountDataSource,
  })  : //------Firebase Storage------
        this._publicationStore = firebaseStorage.ref().child(_publicationsPath),
        this._replyStore = firebaseStorage.ref().child(_repliesPath),
        //------Firestore------
        this._reactCollection = firestore.collection(_reactsPath),
        this._publicationCollection = firestore.collection(_publicationsPath),
        this._followCollection = firestore.collection(_followersPath),
        this._replyCollection = firestore.collection(_repliesPath);

  @override
  Future<RequestResponse<PublicationEntity>> deletePublication(
      PublicationEntity publication) async {
    try {
      await _publicationCollection.document(publication.publicationId).delete();
      return RequestResponse.success(publication..updatedAt = DateTime.now());
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<List<PublicationEntity>>> feed(
      {int page, int itemsPerPage}) async {
    if (page < 0)
      return RequestResponse.fail(404.toString(), ["Pagina inválida"]);
    try {
      if (page == 0) {
        return RequestResponse.success(await _firstFeedQuery(itemsPerPage));
      } else {
        return RequestResponse.success(await _nextFeedQueries(itemsPerPage));
      }
    } catch (e) {
      return errorFirebase<List<PublicationEntity>>(e, 401);
    }
  }

  Future<List<PublicationEntity>> _firstFeedQuery(int itemsPerPage) async {
    var baseQuery = _publicationCollection
        .orderBy('created_at', descending: true)
        .limit(itemsPerPage);
    _olderFeedQuery = baseQuery;
    var docs = await _olderFeedQuery.getDocuments();
    _nextFeedQuery = baseQuery.startAfterDocument(docs.documents.last);
    return docs.documents
        .map((doc) => PublicationEntity.fromJson(doc.data))
        .toList()
        .cast<PublicationEntity>();
  }

  Future<List<PublicationEntity>> _nextFeedQueries(int itemsPerPage) async {
    var baseQuery = _publicationCollection
        .orderBy('created_at', descending: true)
        .limit(itemsPerPage);
    _olderFeedQuery = _nextFeedQuery;
    var docs = await _olderFeedQuery.getDocuments();
    _nextFeedQuery = baseQuery.startAfterDocument(docs.documents.last);
    return docs.documents
        .map((doc) => PublicationEntity.fromJson(doc.data))
        .toList()
        .cast<PublicationEntity>();
  }

  @override
  Future<RequestResponse<List<PublicationEntity>>> myPublications(String userId,
      {int page, int itemPerPage}) async {
    try {
      var docs = await _publicationCollection
          .where('user_id', isEqualTo: userId)
          .getDocuments();
      return RequestResponse.success(docs.documents
          .map((doc) => PublicationEntity.fromJson(doc.data))
          .toList()
          .cast<PublicationEntity>());
    } catch (e) {
      return errorFirebase<List<PublicationEntity>>(e, 401);
    }
  }

  @override
  Future<RequestResponse<List<PublicationEntity>>> publicationsFollowed(
      String userId,
      {int page,
      int itemPerPage}) async {
    try {
      var docsIds = await _followCollection
          .where('user_id', isEqualTo: userId)
          .getDocuments();
      var futures = docsIds.documents
          .map((d) =>
              _publicationCollection.document(d.data['publication_id']).get())
          .toList();
      var pubDocs = await Future.wait(futures);
      return RequestResponse.success(pubDocs
          .map((doc) => PublicationEntity.fromJson(doc.data))
          .toList()
          .cast<PublicationEntity>());
    } catch (e) {
      return errorFirebase<List<PublicationEntity>>(e, 401);
    }
  }

  @override
  Future<RequestResponse<PublicationEntity>> publish(
      PublicationEntity publication) async {
    var user = await accountDataSource.currentUser;
    if (user == null) return RequestResponse.authFail(action: "publicar");
    try {
      var uploadedFiles = await _uploadFile(publication.resources);
      var doc = await _publicationCollection.add((publication
            ..userId = user.userId
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now()
            ..resources = uploadedFiles)
          .toJson());
      publication.publicationId = doc.documentID;
      doc.setData({"publication_id": publication.publicationId}, merge: true);
      return RequestResponse.success(publication);
    } catch (e) {
      print(e);
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  Future<List<PublicationResource>> _uploadFile(
      List<PublicationResource> list) async {
    var response = <PublicationResource>[];
    for (var i = 0; i < list.length; i++) {
      var res = list[i];
      if (res.type == PublicationResourceType.IMAGE) {
        Image image = decodeImage(File(res.source).readAsBytesSync());
        var imageForUpload = copyResize(image, width: 1024);
        var task = await _publicationStore
            .child('image/img_${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putData(encodeJpg(imageForUpload, quality: 75))
            .onComplete;
        response.add(PublicationResource(
            source: await task.ref.getDownloadURL(), type: res.type));
      } else {
        var file = File(res.source);
        var task = await _publicationStore
            .child(
                'videos/video_${DateTime.now().millisecondsSinceEpoch}.${file.path.split(".").last ?? "mp4"}')
            .putFile(file)
            .onComplete;
        response.add(PublicationResource(
            source: await task.ref.getDownloadURL(), type: res.type));
      }
    }
    return response;
  }

  @override
  Future<RequestResponse<ReactEntity>> reactInPublication(
      ReactEntity react) async {
    var user = await accountDataSource.currentUser;
    if (user == null)
      return RequestResponse.authFail(action: "reagir a uma publicação");
    try {
      var doc = await _reactCollection.add((react
            ..userId = user.userId
            ..createdAt = DateTime.now().toIso8601String())
          .toJson());

      react.reactId = doc.documentID;
      await doc.setData({"react_id": react.reactId}, merge: true);
      return RequestResponse.success(react);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReactEntity>> reactInReply(ReactEntity react) async {
    var user = await accountDataSource.currentUser;
    if (user == null)
      return RequestResponse.authFail(action: "reagir a um comentário");
    try {
      var doc = await _reactCollection.add((react
            ..userId = user.userId
            ..createdAt = DateTime.now().toIso8601String())
          .toJson());
      // TODO: Upload files
      react.reactId = doc.documentID;
      await doc.setData({"react_id": react.reactId}, merge: true);
      return RequestResponse.success(react);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReplyEntity>> removeReplyToPublication(
      ReplyEntity reply) async {
    var user = await accountDataSource.currentUser;
    if (user == null)
      return RequestResponse.authFail(action: "deletar um comentário");
    try {
      await _replyCollection.document(reply.replyId).delete();
      return RequestResponse.success(
          reply..updatedAt = DateTime.now().toIso8601String());
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReplyEntity>> replyToPublication(
      ReplyEntity reply) async {
    var user = await accountDataSource.currentUser;
    if (user == null)
      return RequestResponse.authFail(action: "publicar um comentário");
    try {
      var doc = await _replyCollection.add((reply
            ..userId = user.userId
            ..createdAt = DateTime.now().toIso8601String())
          .toJson());

      reply.replyId = doc.documentID;
      await doc.setData({"reply_id": reply.replyId}, merge: true);
      return RequestResponse.success(reply);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReactEntity>> unReactInPublication(
      String publicationId, String userId) async {
    try {
      var user = await accountDataSource.currentUser;
      if (user == null)
        return RequestResponse.authFail(action: "remover uma reação");
      var docs = await _reactCollection
          .where("user_id", isEqualTo: userId)
          .where("publication_id", isEqualTo: publicationId)
          .getDocuments();
      if (docs.documents.isEmpty)
        return RequestResponse.fail("404",
            ["Não possui nenhuma reação registrada para essa publicação."]);
      for (var doc in docs.documents) {
        await doc.reference.delete();
      }
      return RequestResponse.success(
          ReactEntity.fromJson(docs.documents.first?.data));
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReactEntity>> unReactInReply(
      String reactId, String userId) async {
    try {
      var user = await accountDataSource.currentUser;
      if (user == null)
        return RequestResponse.authFail(action: "remover uma reação");
      var docs = await _reactCollection
          .where("user_id", isEqualTo: userId)
          .where("publication_id", isEqualTo: reactId)
          .limit(1)
          .getDocuments();
      if (docs.documents.isEmpty)
        return RequestResponse.fail("404",
            ["Não possui nenhuma reação registrada para esse comentario."]);
      docs.documents
          .forEach((doc) => _reactCollection.document(doc.documentID).delete());
      return RequestResponse.success(
          ReactEntity.fromJson(docs.documents.first?.data));
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<PublicationEntity>> updatePublication(
      PublicationEntity publication) async {
    var user = await accountDataSource.currentUser;
    if (user == null) return RequestResponse.authFail(action: "publicar");
    try {
      await _publicationCollection.document().setData(
          (publication..updatedAt = DateTime.now()).toJson(),
          merge: true);
      return RequestResponse.success(publication);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReplyEntity>> updateReplyToPublication(
      ReplyEntity reply) async {
    try {
      var user = await accountDataSource.currentUser;
      if (user == null)
        return RequestResponse.authFail(action: "atualizar um comentario");
      await _replyCollection.document(reply.replyId).setData(
          (reply..updatedAt = DateTime.now().toIso8601String()).toJson(),
          merge: true);
      return RequestResponse.success(reply);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<FollowEntity>> followPublication(
      FollowEntity follow) async {
    try {
      var user = await accountDataSource.currentUser;
      if (user == null)
        return RequestResponse.authFail(action: "seguir uma publicação");
      var doc = await _followCollection
          .add((follow..createdAt = DateTime.now().toIso8601String()).toJson());
      await doc.setData({"follow_id": doc.documentID}, merge: true);
      return RequestResponse.success(follow..followId = doc.documentID);
    } catch (e) {
      return errorFirebase<PublicationEntity>(e, 23);
    }
  }

  @override
  Future<RequestResponse<ReactEntity>> hasReactInThisPublication(
      PublicationEntity publication) async {
    try {
      var user = await accountDataSource.currentUser;
      var react = await _reactCollection
          .where("publication_id", isEqualTo: publication.publicationId)
          .where("user_id", isEqualTo: user.userId)
          .limit(1)
          .getDocuments();
      if (react.documents.isNotEmpty)
        return RequestResponse.success(
            ReactEntity.fromJson(react.documents.first.data));
      return RequestResponse.notFound(resource: "reação");
    } catch (err) {
      return errorFirebase<ReactEntity>(err, 23);
    }
  }

  @override
  Future<RequestResponse<ReactEntity>> hasReactInThisReply(
      ReplyEntity reply) async {
    try {
      var user = await accountDataSource.currentUser;
      var react = await _reactCollection
          .where("reply_id", isEqualTo: reply.replyId)
          .where("user_id", isEqualTo: user.userId)
          .limit(1)
          .getDocuments();
      if (react.documents.isNotEmpty)
        return RequestResponse.success(
            ReactEntity.fromJson(react.documents.first.data));
      return RequestResponse.notFound(resource: "reação");
    } catch (err) {
      return errorFirebase<ReactEntity>(err, 23);
    }
  }

  @override
  Future<RequestResponse<List<ReplyEntity>>> repliesFromAPublication(
      String publicationId,
      {int page,
      int itemsPerPage}) async {
    if (page < 0)
      return RequestResponse.fail(404.toString(), ["Pagina inválida"]);
    try {
      if (page == 0) {
        return RequestResponse.success(
            await _firstReplyQuery(itemsPerPage, publicationId));
      } else {
        return RequestResponse.success(
            await _nextReplyQuery(itemsPerPage, publicationId));
      }
    } catch (e) {
      return errorFirebase<List<ReplyEntity>>(e, 401);
    }
  }

  Future<List<ReplyEntity>> _firstReplyQuery(
      int itemsPerPage, String publicationId) async {
    var baseQuery = _replyCollection
        .orderBy('created_at', descending: true)
        .where('publication_id', isEqualTo: publicationId)
        .limit(itemsPerPage);
    _olderReplyQueryMap[publicationId] = baseQuery;
    var docs = await baseQuery.getDocuments();
    if (docs.documents.isEmpty) return [];
    _nextReplyQueryMap[publicationId] =
        baseQuery.startAfterDocument(docs.documents.last);
    return docs.documents
        .map((doc) => ReplyEntity.fromJson(doc.data))
        .toList()
        .cast<ReplyEntity>();
  }

  Future<List<ReplyEntity>> _nextReplyQuery(
      int itemsPerPage, String publicationId) async {
    var baseQuery = _nextReplyQueryMap[publicationId];
    _olderReplyQueryMap[publicationId] = _nextReplyQueryMap[publicationId];
    var docs = await baseQuery.getDocuments();
    if (docs.documents.isEmpty) return [];
    _nextReplyQueryMap[publicationId] =
        baseQuery.startAfterDocument(docs.documents.last);
    return docs.documents
        .map((doc) => ReplyEntity.fromJson(doc.data))
        .toList()
        .cast<ReplyEntity>();
  }
}
