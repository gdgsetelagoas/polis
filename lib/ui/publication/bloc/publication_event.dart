import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';

@immutable
abstract class PublicationEvent extends Equatable {
  PublicationEvent([List props = const []]) : super(props);
}

class PublicationPublishButtonPressed extends PublicationEvent {
  final PublicationEntity publication;

  PublicationPublishButtonPressed(this.publication);

  @override
  String toString() {
    return 'PublicationPublishButtonPressed{publication: $publication}';
  }
}

class PublicationToDraftEvent extends PublicationEvent {
  final PublicationEntity publication;

  PublicationToDraftEvent(this.publication);

  @override
  String toString() {
    return 'PublicationToDraftEvent{publication: $publication}';
  }
}

class PublicationToEditing extends PublicationEvent {
  final PublicationEvent publication;

  PublicationToEditing(this.publication);

  @override
  String toString() {
    return 'PublicationToEditing{publication: $publication}';
  }
}

class PublicationCancelButtonPressed extends PublicationEvent {
  @override
  String toString() {
    return 'PublicationCancelButtonPressed{}';
  }
}

class PublicationNothing extends PublicationEvent {
  @override
  String toString() {
    return 'PublicationNothing{}';
  }
}
