import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/user_entity.dart';

@immutable
abstract class ReplyState extends Equatable {
  ReplyState([List props = const []]) : super(props);
}

class InitialReplyState extends ReplyState {}

class ReplyProcessingReactInReply extends ReplyState {
  final bool processing;

  ReplyProcessingReactInReply(this.processing) : super([processing]);
}

class ReplyReactInReplySuccess extends ReplyState {
  final ReactEntity react;

  ReplyReactInReplySuccess(this.react) : super([react]);
}

class ReplyReactInReplyFail extends ReplyState {
  final List<String> errors;

  ReplyReactInReplyFail(this.errors) : super(errors);
}

class ReplyUserDataLoaded extends ReplyState {
  final UserEntity user;

  ReplyUserDataLoaded(this.user) : super([user]);
}
