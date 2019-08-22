import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';

@immutable
abstract class FeedEvent extends Equatable {
  FeedEvent([List props = const []]) : super(props);
}

enum FeedContext { GENERAL, MINE, FOLLOWED }

class FeedLoadFeed extends FeedEvent {
  final FeedContext feedContext;

  FeedLoadFeed(this.feedContext);

  @override
  String toString() {
    return 'FeedLoadFeed{feedContext: $feedContext}';
  }
}

class FeedLoadMore extends FeedEvent {
  final FeedContext feedContext;

  FeedLoadMore(this.feedContext);

  @override
  String toString() {
    return 'FeedLoadMore{feedContext: $feedContext}';
  }
}

class FeedRefresh extends FeedEvent {
  final FeedContext feedContext;

  FeedRefresh(this.feedContext);

  @override
  String toString() {
    return 'FeedRefresh{feedContext: $feedContext}';
  }
}

class FeedButtonReactPublicationPressed extends FeedEvent {
  final ReactEntity react;

  FeedButtonReactPublicationPressed({@required this.react})
      : assert(react != null);

  @override
  String toString() {
    return 'FeedButtonReactPublicationPressed{react: $react}';
  }
}

class FeedButtonRepliesPublicationPressed extends FeedEvent {
  final ReplyEntity reply;

  FeedButtonRepliesPublicationPressed({@required this.reply});

  @override
  String toString() {
    return 'FeedButtonRepliesPublicationPressed{reply: $reply}';
  }
}

class FeedButtonFollowPublicationPressed extends FeedEvent {
  final FollowEntity follow;

  FeedButtonFollowPublicationPressed({@required this.follow});

  @override
  String toString() {
    return 'FeedButtonFollowPublicationPressed{entity: $follow}';
  }
}

class FeedButtonSignUpPublicationPressed extends FeedEvent {
  FeedButtonSignUpPublicationPressed();

  @override
  String toString() {
    return 'FeedButtonSignUpPublicationPressed{}';
  }
}

class FeedButtonSignInPublicationPressed extends FeedEvent {
  FeedButtonSignInPublicationPressed();

  @override
  String toString() {
    return 'FeedButtonSignInPublicationPressed{}';
  }
}

class FeedButtonMenuItemPressed extends FeedEvent {
  final String option;

  FeedButtonMenuItemPressed({@required this.option});

  @override
  String toString() {
    return 'FeedButtonMenuItemPressed{option: $option}';
  }
}

class FeedLoadUserData extends FeedEvent {
  final String userId;

  FeedLoadUserData({this.userId}) : super([userId]);
}

class FeedLoadReactForPublicationStatus extends FeedEvent {
  final PublicationEntity publication;

  FeedLoadReactForPublicationStatus({this.publication}) : super([publication]);
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
  }) : super([reply, publication, itemsPerPage, page]);
}
