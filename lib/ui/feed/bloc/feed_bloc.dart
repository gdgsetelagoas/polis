import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final AccountDataSource accountDataSource;
  final PublicationDataSource publicationDataSource;
  int _page = 0;
  final int _itemsPerPage = 25;
  final BehaviorSubject<bool> _processingPublisher = BehaviorSubject();
  FeedEvent _lastEvent;

  FeedBloc(
      {@required this.publicationDataSource, @required this.accountDataSource});

  @override
  FeedState get initialState => InitialFeedState();

  @override
  void dispose() {
    _processingPublisher.close();
    super.dispose();
  }

  @override
  void onEvent(FeedEvent event) async {
    var user = await accountDataSource.currentUser;
    if (user == null) return;
    if (event is FeedButtonReactPublicationPressed) {
      _processingPublisher.sink.add(true);
      await publicationDataSource
          .reactInPublication(event.react..userId = user.userId);
      _processingPublisher.sink.add(false);
    } else if (event is FeedButtonFollowPublicationPressed) {
      _processingPublisher.sink.add(true);
      await publicationDataSource
          .followPublication(event.follow..userId = user.userId);
      _processingPublisher.sink.add(false);
    } else if (event is FeedButtonRepliesPublicationPressed) {
      _processingPublisher.sink.add(true);
      await publicationDataSource
          .replyToPublication(event.reply..userId = user.userId);
      _processingPublisher.sink.add(false);
    }
  }

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedLoadMore && event == this._lastEvent) return;
    _processingPublisher.sink.add(true);
    if (event is FeedLoadFeed) {
      var user = await accountDataSource.currentUser;
      var response;
      if (event.feedContext == FeedContext.FOLLOWED)
        response = await publicationDataSource.publicationsFollowed(user?.userId,
            page: _page, itemPerPage: _itemsPerPage);
      else if (event.feedContext == FeedContext.MINE)
        response = await publicationDataSource.myPublications(user?.userId,
            page: _page, itemPerPage: _itemsPerPage);
      else
        response = await publicationDataSource.feed(
            page: _page, itemsPerPage: _itemsPerPage);
      if (response.isSuccess) {
        if (response.data.length >= _itemsPerPage) _page++;
        if (response.data.isEmpty)
          yield FeedEmptyList(feedContext: event.feedContext);
        else
          yield FeedList(response.data);
      }
    }
    this._lastEvent = event;
    _processingPublisher.sink.add(false);
  }

  Future<UserEntity> getUserData(String userId) async {
    return accountDataSource.getUserById(userId);
  }

  Stream<bool> get outProcessing => _processingPublisher.stream;
}
