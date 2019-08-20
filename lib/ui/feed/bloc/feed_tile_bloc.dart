import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import 'package:res_publica/model/request_response.dart';

import './bloc.dart';

class FeedTileBloc extends Bloc<FeedEvent, FeedState> {
  final AccountDataSource accountDataSource;
  final PublicationDataSource publicationDataSource;

  FeedTileBloc({
    @required this.publicationDataSource,
    @required this.accountDataSource,
  });

  @override
  FeedState get initialState => InitialFeedState();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedButtonReactPublicationPressed) {
      yield FeedProcessingReactInPublication(true);
      RequestResponse response;
      if (event.react.reactId != null && event.react.reactId.isNotEmpty) {
        response = await publicationDataSource.unReactInPublication(
            event.react.publicationId, event.react.userId);
        yield FeedProcessingReactInPublication(false);
        if (response.isSuccess)
          yield FeedReactInPublicationsSuccess(null);
        else
          yield FeedReactInPublicationsFail(response.errors ?? []);
      } else {
        response = await publicationDataSource.reactInPublication(event.react);
        yield FeedProcessingReactInPublication(false);
        if (response.isSuccess)
          yield FeedReactInPublicationsSuccess(response.data);
        else
          yield FeedReactInPublicationsFail(response.errors ?? []);
      }
    }
    if (event is FeedLoadReactForPublicationStatus) {
      yield FeedProcessingReactInPublication(true);
      var response = await publicationDataSource
          .hasReactInThisPublication(event.publication);
      yield FeedProcessingReactInPublication(false);
      if (response.isSuccess) {
        yield FeedReactInPublicationsSuccess(response.data);
      } else {
        yield FeedReactInPublicationsFail(response.errors);
      }
    }

    if (event is FeedLoadUserData) {
      var user = await accountDataSource.getUserById(event.userId);
      yield FeedUserDataLoaded(user);
    }

    if (event is FeedLoadReplies) {
      var repliesResponse = await publicationDataSource.repliesFromAPublication(
          event.publication.publicationId,
          itemsPerPage: event.itemsPerPage,
          page: event.page);
      if (repliesResponse.isSuccess) {
        yield FeedRepliesLoaded(
            replies: repliesResponse.data,
            currentPage: event.page,
            nextPage: repliesResponse.data.length == event.itemsPerPage
                ? event.page + 1
                : null,
            itemsPerPage: event.itemsPerPage);
      }
    }
  }
}
