import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class ProfileEditingName extends ProfileSigned {
  @override
  String toString() => "ProfileEditingName";
}

class ProfileLoading extends ProfileState {
  @override
  String toString() => "ProfileLoading";
}

class ProfileNotSigned extends ProfileState {
  @override
  String toString() => "ProfileNotSigned";
}

class ProfileSigned extends ProfileState {
  final UserEntity user;

  ProfileSigned({@required this.user});

  @override
  String toString() => "ProfileSigned";
}
