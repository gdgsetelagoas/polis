import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsEvent extends Equatable {}

class SettingsSignOut extends SettingsEvent {
  @override
  String toString() {
    return 'SettingsSignOut{}';
  }

  @override
  List<Object> get props => [];
}
