import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const []]) : super(props);
}

class SettingsSignOut extends SettingsEvent {
  @override
  String toString() {
    return 'SettingsSignOut{}';
  }
}
