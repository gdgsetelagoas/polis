import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/feed_event.dart';

@immutable
abstract class FeedState extends Equatable {
  FeedState([List props = const []]) : super(props);
}

class InitialFeedState extends FeedState {}

class FeedList extends FeedState {
  final List<PublicationEntity> publications;
  final UserEntity currentUser;

  FeedList(this.publications, {this.currentUser})
      : super([publications, currentUser]);

  @override
  String toString() {
    return 'FeedList{publications.length: ${publications.length}}';
  }
}

class FeedEmptyList extends FeedState {
  final FeedContext feedContext;

  FeedEmptyList({@required this.feedContext}) : super([feedContext]);

  @override
  String toString() {
    return 'FeedEmptyList{feedContext: $feedContext}';
  }
}

class FeedProcessingReactInPublication extends FeedState {
  final bool processing;

  FeedProcessingReactInPublication(this.processing) : super([processing]);
}

class FeedReactInPublicationsSuccess extends FeedState {
  final ReactEntity react;

  FeedReactInPublicationsSuccess(this.react) : super([react]);
}

class FeedReactInPublicationsFail extends FeedState {
  final List<String> errors;

  FeedReactInPublicationsFail(this.errors) : super([errors]);
}

class FeedUserDataLoaded extends FeedState {
  final UserEntity user;

  FeedUserDataLoaded(this.user) : super([user]);
}

class FeedRepliesLoaded extends FeedState {
  final List<ReplyEntity> replies;
  final int currentPage, nextPage, itemsPerPage;

  FeedRepliesLoaded(
      {@required this.replies,
      this.currentPage,
      this.nextPage,
      this.itemsPerPage})
      : super([replies, currentPage, nextPage, itemsPerPage]);
}
