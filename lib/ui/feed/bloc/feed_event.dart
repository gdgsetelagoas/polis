import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';

@immutable
abstract class FeedEvent extends Equatable {}

enum FeedContext { GENERAL, MINE, FOLLOWED }

class FeedLoadFeed extends FeedEvent {
  final FeedContext feedContext;

  FeedLoadFeed(this.feedContext);

  @override
  String toString() {
    return 'FeedLoadFeed{feedContext: $feedContext}';
  }

  @override
  List<Object> get props => [feedContext];
}

class FeedLoadMore extends FeedEvent {
  final FeedContext feedContext;

  FeedLoadMore(this.feedContext);

  @override
  String toString() {
    return 'FeedLoadMore{feedContext: $feedContext}';
  }

  @override
  List<Object> get props => [feedContext];
}

class FeedRefresh extends FeedEvent {
  final FeedContext feedContext;

  FeedRefresh(this.feedContext);

  @override
  String toString() {
    return 'FeedRefresh{feedContext: $feedContext}';
  }

  @override
  List<Object> get props => [feedContext];
}

class FeedButtonReactPublicationPressed extends FeedEvent {
  final ReactEntity react;

  FeedButtonReactPublicationPressed({@required this.react})
      : assert(react != null);

  @override
  String toString() {
    return 'FeedButtonReactPublicationPressed{react: $react}';
  }

  @override
  List<Object> get props => [react];
}

class FeedButtonRepliesPublicationPressed extends FeedEvent {
  final ReplyEntity reply;

  FeedButtonRepliesPublicationPressed({@required this.reply});

  @override
  String toString() {
    return 'FeedButtonRepliesPublicationPressed{reply: $reply}';
  }

  @override
  List<Object> get props => [reply];
}

class FeedButtonFollowPublicationPressed extends FeedEvent {
  final FollowEntity follow;

  FeedButtonFollowPublicationPressed({@required this.follow});

  @override
  String toString() {
    return 'FeedButtonFollowPublicationPressed{entity: $follow}';
  }

  @override
  List<Object> get props => [follow];
}

class FeedButtonSignUpPublicationPressed extends FeedEvent {
  FeedButtonSignUpPublicationPressed();

  @override
  String toString() {
    return 'FeedButtonSignUpPublicationPressed{}';
  }

  @override
  List<Object> get props => [];
}

class FeedButtonSignInPublicationPressed extends FeedEvent {
  FeedButtonSignInPublicationPressed();

  @override
  String toString() {
    return 'FeedButtonSignInPublicationPressed{}';
  }

  @override
  List<Object> get props => [];
}

class FeedButtonMenuItemPressed extends FeedEvent {
  final String option;

  FeedButtonMenuItemPressed({@required this.option});

  @override
  String toString() {
    return 'FeedButtonMenuItemPressed{option: $option}';
  }

  @override
  List<Object> get props => [option];
}

class FeedLoadUserData extends FeedEvent {
  final String userId;

  FeedLoadUserData({this.userId});

  @override
  List<Object> get props => [userId];
}

class FeedLoadReactForPublicationStatus extends FeedEvent {
  final PublicationEntity publication;

  FeedLoadReactForPublicationStatus({this.publication});

  @override
  List<Object> get props => [publication];
}

class FeedLoadReplies extends FeedEvent {
  final PublicationEntity publication;
  final ReplyEntity reply;
  final int itemsPerPage, page;

  FeedLoadReplies({
    @required this.publication,
    this.reply,
    this.itemsPerPage = 25,
    this.page = 0,
  });

  @override
  List<Object> get props => [reply, publication, itemsPerPage, page];
}
