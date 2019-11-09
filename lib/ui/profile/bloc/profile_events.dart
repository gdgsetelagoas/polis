import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class ProfileEvent extends Equatable {}

class ProfileUpdateName extends ProfileEvent {
  final String name;

  ProfileUpdateName({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'ProfileUpdateName{name: $name}';
  }
}

class ProfileUpdatingName extends ProfileEvent {
  final bool editing;

  ProfileUpdatingName({@required this.editing});

  @override
  List<Object> get props => [editing];

  @override
  String toString() {
    return 'ProfileUpdateName{editing: $editing}';
  }
}

class ProfileUpdatePhoto extends ProfileEvent {
  final String path;

  ProfileUpdatePhoto({@required this.path});

  @override
  List<Object> get props => [path];

  @override
  String toString() {
    return 'ProfileUpdateName{name: $path}';
  }
}

class ProfileUserAuthenticatedFail extends ProfileEvent {
  ProfileUserAuthenticatedFail();

  @override
  String toString() {
    return 'ProfileUserAuthenticatedFail';
  }

  @override
  List<Object> get props => [];
}

class ProfileUserAuthenticated extends ProfileEvent {
  final UserEntity user;

  ProfileUserAuthenticated({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'ProfileUpdateName{user: $user}';
  }
}

class ProfileUserAuthenticating extends ProfileEvent {
  ProfileUserAuthenticating();

  @override
  String toString() {
    return 'ProfileUpdateName';
  }

  @override
  List<Object> get props => [];
}
