import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import 'package:res_publica/model/user_entity.dart';

import './bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final AccountDataSource accountDataSource;
  final PublicationDataSource publicationDataSource;
  int _page = 0;
  final int _itemsPerPage = 25;

  FeedBloc(
      {@required this.publicationDataSource, @required this.accountDataSource});

  @override
  FeedState get initialState => InitialFeedState();

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedLoadFeed) {
      var user = await accountDataSource.currentUser;
      var response;
      if (event.feedContext == FeedContext.FOLLOWED)
        response = await publicationDataSource.publicationsFollowed(user.userId,
            page: _page, itemPerPage: _itemsPerPage);
      else if (event.feedContext == FeedContext.MINE)
        response = await publicationDataSource.myPublications(user.userId,
            page: _page, itemPerPage: _itemsPerPage);
      else
        response = await publicationDataSource.feed(
            page: _page, itemsPerPage: _itemsPerPage);
      if (response.isSuccess) {
        if (response.data.isEmpty)
          yield FeedEmptyList();
        else
          yield FeedList(response.data);
      }
    }
  }

  Future<UserEntity> getUserData(String userId) async {
    return accountDataSource.getUserById(userId);
  }
}
