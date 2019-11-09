import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {}

class InitialSettingsState extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsUserSignedOut extends SettingsState {
  @override
  String toString() {
    return 'SettingsUserSignedOut{}';
  }

  @override
  List<Object> get props => [];
}

class SettingsErrors extends SettingsState {
  final List<String> errors;

  SettingsErrors({@required this.errors});

  @override
  String toString() {
    return 'SettingsErrors{errors: $errors}';
  }

  @override
  List<Object> get props => [errors];
}
