import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/reply_entity.dart';

@immutable
abstract class ReplyEvent extends Equatable {
  ReplyEvent([List props = const []]) : super(props);
}

class ReplyLoadReactForReplyStatus extends ReplyEvent {
  final ReplyEntity reply;

  ReplyLoadReactForReplyStatus({@required this.reply}) : super([reply]);
}

class ReplyLoadUserData extends ReplyEvent {
  final String userId;

  ReplyLoadUserData({@required this.userId}) : super([userId]);
}
