import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';

@immutable
abstract class PublicationEvent extends Equatable {}

class PublicationPublishButtonPressed extends PublicationEvent {
  final PublicationEntity publication;

  PublicationPublishButtonPressed(this.publication);

  @override
  String toString() {
    return 'PublicationPublishButtonPressed{publication: $publication}';
  }

  @override
  List<Object> get props => [publication];
}

class PublicationToDraftEvent extends PublicationEvent {
  final PublicationEntity publication;

  PublicationToDraftEvent(this.publication);

  @override
  String toString() {
    return 'PublicationToDraftEvent{publication: $publication}';
  }

  @override
  List<Object> get props => [publication];
}

class PublicationToEditing extends PublicationEvent {
  final PublicationEvent publication;

  PublicationToEditing(this.publication);

  @override
  String toString() {
    return 'PublicationToEditing{publication: $publication}';
  }

  @override
  List<Object> get props => [publication];
}

class PublicationCancelButtonPressed extends PublicationEvent {
  @override
  String toString() {
    return 'PublicationCancelButtonPressed{}';
  }

  @override
  List<Object> get props => [];
}

class PublicationNothing extends PublicationEvent {
  @override
  String toString() {
    return 'PublicationNothing{}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
