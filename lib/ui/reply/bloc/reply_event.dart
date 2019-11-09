import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/reply_entity.dart';

@immutable
abstract class ReplyEvent extends Equatable {}

class ReplyLoadReactForReplyStatus extends ReplyEvent {
  final ReplyEntity reply;

  ReplyLoadReactForReplyStatus({@required this.reply});
  @override
  List<Object> get props => [reply];
}

class ReplyLoadUserData extends ReplyEvent {
  final String userId;

  ReplyLoadUserData({@required this.userId});
  @override
  List<Object> get props => [userId];
}
