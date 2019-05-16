import 'package:equatable/equatable.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class SignState extends Equatable {
  SignState([List props = const []]) : super(props);
}

class SignLoading extends SignState {
  final bool loading;

  SignLoading([this.loading = true]);

  @override
  String toString() {
    return 'SignLoading{loading: $loading}';
  }
}

class SignInitial extends SignState {
  @override
  String toString() {
    return 'SignInitial{}';
  }
}

class SignLoginSuccessful extends SignState {
  final UserEntity user;

  SignLoginSuccessful(this.user);

  @override
  String toString() {
    return 'SignLoginSuccessful{user: $user}';
  }
}

class SignLoginFail extends SignState {
  final List<String> errors;

  SignLoginFail(this.errors);

  @override
  String toString() {
    return 'SignLoginFail{errors: $errors}';
  }
}

class SignRegister extends SignState {
  @override
  String toString() {
    return 'SignRegister{}';
  }
}

class SignErrors extends SignState {
  final List<String> errors;

  SignErrors(this.errors);

  @override
  String toString() {
    return 'SignErrors{errors: $errors}';
  }
}
