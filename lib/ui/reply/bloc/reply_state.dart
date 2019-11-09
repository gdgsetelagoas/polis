import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/user_entity.dart';

@immutable
abstract class ReplyState extends Equatable {}

class InitialReplyState extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyProcessingReactInReply extends ReplyState {
  final bool processing;

  ReplyProcessingReactInReply(this.processing);

  @override
  List<Object> get props => [processing];
}

class ReplyReactInReplySuccess extends ReplyState {
  final ReactEntity react;

  ReplyReactInReplySuccess(this.react);

  @override
  List<Object> get props => [react];
}

class ReplyReactInReplyFail extends ReplyState {
  final List<String> errors;

  ReplyReactInReplyFail(this.errors);

  @override
  List<Object> get props => errors;
}

class ReplyUserDataLoaded extends ReplyState {
  final UserEntity user;

  ReplyUserDataLoaded(this.user);
  
  @override
  List<Object> get props => [user];
}
