import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class SignEvent extends Equatable {
  SignEvent([List props = const []]) : super(props);
}

class SignLoginButtonPressed extends SignEvent {
  final String email;
  final String password;

  SignLoginButtonPressed({@required this.email, @required this.password});

  @override
  String toString() {
    return 'SignLoginButtonPressed{email: $email, password: $password}';
  }
}

class SignLoginWithGooglePressed extends SignEvent {
  @override
  String toString() {
    return 'SignLoginWithGooglePressed{}';
  }
}

class SignRegisterButtonPressed extends SignEvent {
  final UserEntity user;

  SignRegisterButtonPressed({this.user});

  @override
  String toString() {
    return 'SignRegisterButtonPressed{user: $user}';
  }
}
