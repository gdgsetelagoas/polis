import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([List props = const []]) : super(props);
}

class InitialSettingsState extends SettingsState {}

class SettingsUserSignedOut extends SettingsState {
  @override
  String toString() {
    return 'SettingsUserSignedOut{}';
  }
}

class SettingsErrors extends SettingsState {
  final List<String> errors;

  SettingsErrors({@required this.errors});

  @override
  String toString() {
    return 'SettingsErrors{errors: $errors}';
  }
}
