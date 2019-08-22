import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  final PublicationDataSource publicationDataSource;
  final AccountDataSource accountDataSource;

  ReplyBloc({
    @required this.publicationDataSource,
    @required this.accountDataSource,
  });

  @override
  ReplyState get initialState => InitialReplyState();

  @override
  Stream<ReplyState> mapEventToState(
    ReplyEvent event,
  ) async* {
    if (event is ReplyLoadReactForReplyStatus) {
      yield ReplyProcessingReactInReply(true);
      var response =
          await publicationDataSource.hasReactInThisReply(event.reply);
      yield ReplyProcessingReactInReply(false);
      if (response.isSuccess) {
        yield ReplyReactInReplySuccess(response.data);
      } else {
        yield ReplyReactInReplyFail(response.errors);
      }
    }

    if (event is ReplyLoadUserData) {
      var user = await accountDataSource.getUserById(event.userId);
      yield ReplyUserDataLoaded(user);
    }
  }
}
