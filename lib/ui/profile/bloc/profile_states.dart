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
  final bool loading;

  ProfileLoading(this.loading) : super([loading]);
}

class ProfileNotSigned extends ProfileState {
  @override
  String toString() => "ProfileNotSigned";
}

class ProfileSigned extends ProfileState {
  final UserEntity user;

  ProfileSigned({@required this.user}) : super([user]);

  @override
  String toString() => "ProfileSigned";
}

class ProfileErrors extends ProfileState {
  final List<String> errors;

  ProfileErrors({@required this.errors}) : super([errors]);

  @override
  String toString() {
    return 'ProfileErrors{errors: $errors}';
  }
}
