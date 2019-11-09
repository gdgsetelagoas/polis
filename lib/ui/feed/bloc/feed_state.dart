import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/feed_event.dart';

@immutable
abstract class FeedState extends Equatable {}

class InitialFeedState extends FeedState {
  @override
  List<Object> get props => [];
}

class FeedList extends FeedState {
  final List<PublicationEntity> publications;
  final UserEntity currentUser;

  FeedList(this.publications, {this.currentUser});

  @override
  String toString() {
    return 'FeedList{publications.length: ${publications.length}}';
  }

  @override
  List<Object> get props => [publications, currentUser];
}

class FeedEmptyList extends FeedState {
  final FeedContext feedContext;

  FeedEmptyList({@required this.feedContext});

  @override
  String toString() {
    return 'FeedEmptyList{feedContext: $feedContext}';
  }

  @override
  List<Object> get props => [feedContext];
}

class FeedProcessingReactInPublication extends FeedState {
  final bool processing;

  FeedProcessingReactInPublication(this.processing);

  @override
  List<Object> get props => [processing];
}

class FeedReactInPublicationsSuccess extends FeedState {
  final ReactEntity react;

  FeedReactInPublicationsSuccess(this.react);

  @override
  List<Object> get props => [react];
}

class FeedReactInPublicationsFail extends FeedState {
  final List<String> errors;

  FeedReactInPublicationsFail(this.errors);

  @override
  List<Object> get props => [errors];
}

class FeedUserDataLoaded extends FeedState {
  final UserEntity user;

  FeedUserDataLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class FeedRepliesLoaded extends FeedState {
  final List<ReplyEntity> replies;
  final int currentPage, nextPage, itemsPerPage;

  FeedRepliesLoaded(
      {@required this.replies,
      this.currentPage,
      this.nextPage,
      this.itemsPerPage});

  @override
  List<Object> get props => [replies, currentPage, nextPage, itemsPerPage];
}
