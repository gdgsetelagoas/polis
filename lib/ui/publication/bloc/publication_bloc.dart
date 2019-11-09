import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';

import './bloc.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  final AccountDataSource accountDataSource;
  final PublicationDataSource publicationDataSource;
  PublicationState _lastState = PublicationCreate();

  PublicationBloc({
    @required this.accountDataSource,
    @required this.publicationDataSource,
  }) {
    add(PublicationNothing());
  }

  @override
  PublicationState get initialState => _lastState;

  @override
  Stream<PublicationState> mapEventToState(
    PublicationEvent event,
  ) async* {
    yield PublicationProcessing(true);
    var user = await accountDataSource.currentUser;
    _lastState = PublicationCreate(user: user);
    if (event is PublicationPublishButtonPressed) {
      if (event.publication.resources.isNotEmpty &&
          event.publication.subtitle.isNotEmpty) {
        event.publication..userId = user.userId;
        var response = await publicationDataSource.publish(event.publication);
        if (response.isSuccess)
          _lastState = PublicationSuccessful(response.data);
        else
          _lastState = PublicationErrors(response.errors);
      } else {
        yield PublicationEmpty();
      }
    }
    if (event is PublicationCancelButtonPressed) {
      yield PublicationCancel();
    }
    yield PublicationProcessing(false);
    yield _lastState;
  }
}
