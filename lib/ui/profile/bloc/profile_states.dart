import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class ProfileState extends Equatable {}

class ProfileEditingName extends ProfileSigned {
  @override
  String toString() => "ProfileEditingName";
}

class ProfileLoading extends ProfileState {
  final bool loading;

  ProfileLoading(this.loading);

  @override
  List<Object> get props => [loading];
}

class ProfileNotSigned extends ProfileState {
  @override
  String toString() => "ProfileNotSigned";

  @override
  List<Object> get props => [];
}

class ProfileSigned extends ProfileState {
  final UserEntity user;

  ProfileSigned({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => "ProfileSigned";
}

class ProfileErrors extends ProfileState {
  final List<String> errors;

  ProfileErrors({@required this.errors});

  @override
  List<Object> get props => [errors];

  @override
  String toString() {
    return 'ProfileErrors{errors: $errors}';
  }
}

class ProfileOpenSignInScreen extends ProfileState {
  @override
  List<Object> get props => [];
}
