import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  @override
  ReplyState get initialState => InitialReplyState();

  @override
  Stream<ReplyState> mapEventToState(
    ReplyEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
