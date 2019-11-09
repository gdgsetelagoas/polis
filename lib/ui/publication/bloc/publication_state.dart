import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/user_entity.dart';

@immutable
abstract class PublicationState extends Equatable {}

class InitialPostState extends PublicationState {
  @override
  String toString() {
    return 'InitialPostState{}';
  }

  @override
  List<Object> get props => [];
}

class PublicationErrors extends PublicationState {
  final List<String> errors;

  PublicationErrors(this.errors);

  @override
  String toString() {
    return 'PublicationErrors{errors: $errors}';
  }

  @override
  List<Object> get props => [errors];
}

class PublicationCreate extends PublicationState {
  final UserEntity user;

  PublicationCreate({this.user});

  @override
  String toString() {
    return 'PublicationCreate{user: $user}';
  }

  @override
  List<Object> get props => [user];
}

class PublicationEdit extends PublicationCreate {
  final PublicationEntity publication;

  PublicationEdit(this.publication);

  @override
  String toString() {
    return 'PublicationEdit{publication: $publication}';
  }
}

class PublicationSuccessful extends PublicationState {
  final PublicationEntity publication;

  PublicationSuccessful(this.publication);

  @override
  String toString() {
    return 'PublicationSuccessful{publication: $publication}';
  }

  @override
  List<Object> get props => [publication];
}

class PublicationProcessing extends PublicationState {
  final bool isProcessing;

  PublicationProcessing([this.isProcessing = false]);

  @override
  String toString() {
    return 'PublicationProcessing{isProcessing: $isProcessing}';
  }

  @override
  List<Object> get props => [isProcessing];
}

class PublicationCancel extends PublicationState {
  final bool isCancel;

  PublicationCancel([this.isCancel = false]);

  @override
  String toString() {
    return 'PublicationCancel{isCancel: $isCancel}';
  }

  @override
  List<Object> get props => [isCancel];
}

class PublicationEmpty extends PublicationState {
  @override
  String toString() {
    return 'PublicationEmpty{}';
  }

  @override
  List<Object> get props => [];
}
