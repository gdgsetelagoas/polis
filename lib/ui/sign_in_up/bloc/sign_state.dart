import 'package:equatable/equatable.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class SignState extends Equatable {}

class SignLoading extends SignState {
  final bool loading;

  SignLoading([this.loading = true]);

  @override
  String toString() {
    return 'SignLoading{loading: $loading}';
  }

  @override
  List<Object> get props => [loading];
}

class SignInitial extends SignState {
  @override
  String toString() {
    return 'SignInitial{}';
  }

  @override
  List<Object> get props => [];
}

class SignLoginSuccessful extends SignState {
  final UserEntity user;

  SignLoginSuccessful(this.user);

  @override
  String toString() {
    return 'SignLoginSuccessful{user: $user}';
  }

  @override
  List<Object> get props => [user];
}

class SignLoginFail extends SignState {
  final List<String> errors;

  SignLoginFail(this.errors);

  @override
  String toString() {
    return 'SignLoginFail{errors: $errors}';
  }

  @override
  List<Object> get props => [errors];
}

class SignRegister extends SignState {
  @override
  String toString() {
    return 'SignRegister{}';
  }

  @override
  List<Object> get props => [];
}

class SignErrors extends SignState {
  final List<String> errors;

  SignErrors(this.errors);

  @override
  String toString() {
    return 'SignErrors{errors: $errors}';
  }

  @override
  List<Object> get props => [errors];
}
