import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';

@immutable
abstract class FeedState extends Equatable {
  FeedState([List props = const []]) : super(props);
}

class InitialFeedState extends FeedState {}

class FeedList extends FeedState {
  final List<PublicationEntity> publications;

  FeedList(this.publications);

  @override
  String toString() {
    return 'FeedList{publications.length: ${publications.length}}';
  }
}

class FeedEmptyList extends FeedState {
  @override
  String toString() {
    return 'FeedEmptyList{}';
  }
}
