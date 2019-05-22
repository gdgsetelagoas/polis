import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/follow_entity.dart';
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
