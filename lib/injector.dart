import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dioc/dioc.dart' as dioc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/account/remote/firebase_account_data_source.dart';
import 'package:res_publica/data/publication/publication_data_source.dart';
import 'package:res_publica/data/publication/remote/firebase_publication_data_source.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/publication/bloc/publication_bloc.dart';
import 'package:res_publica/ui/settings/bloc/settings_bloc.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_bloc.dart';

class Injector {
  dioc.Container _container;

  Injector() {
    _container = dioc.Container();
  }

  Future resPulica() async {
    _container.reset();
    await _registerFirebase();
    await _registerAppDataSources();
    await _registerUiBlocs();
  }

  P get<P>(String s) =>
      _container.get<P>(creator: s, mode: dioc.InjectMode.create);

  P getSingleton<P>(String s) =>
      _container.get<P>(creator: s, mode: dioc.InjectMode.singleton);

  Future _registerFirebase() async {
    _container.register<FirebaseAuth>((c) => FirebaseAuth.instance,
        name: "FirebaseAuth");
    _container.register<Firestore>((c) => Firestore.instance,
        name: "Firestore");
    _container.register<FirebaseStorage>((c) => FirebaseStorage.instance,
        name: "FirebaseStorage");
    _container.register((c) {
      return GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
          'profile'
        ],
      );
    }, name: "GoogleSignIn");
  }

  Future _registerAppDataSources() async {
    _container.register<AccountDataSource>(
        (c) => FirebaseAccountDataSource(
            firebaseAuth: c.get<FirebaseAuth>(creator: "FirebaseAuth"),
            firebaseStorage: c.get<FirebaseStorage>(creator: "FirebaseStorage"),
            firestore: c.get<Firestore>(creator: "Firestore")),
        name: "AccountDataSource",
        defaultMode: dioc.InjectMode.singleton);

    _container.register<PublicationDataSource>(
        (c) => FirebasePublicationDataSource(
            firebaseStorage: c.get<FirebaseStorage>(creator: "FirebaseStorage"),
            firestore: c.get<Firestore>(creator: "Firestore"),
            accountDataSource:
                c.get<AccountDataSource>(creator: "AccountDataSource")),
        name: "PublicationDataSource");
  }

  Future _registerUiBlocs() async {
    _container.register<ProfileBloc>(
        (c) => ProfileBloc(get<AccountDataSource>("AccountDataSource")),
        name: "ProfileBloc",
        defaultMode: dioc.InjectMode.create);

    _container.register<SettingsBloc>(
        (c) => SettingsBloc(
            accountDataSource: get<AccountDataSource>("AccountDataSource")),
        name: "SettingsBloc",
        defaultMode: dioc.InjectMode.create);

    _container.register<SignBloc>(
        (c) => SignBloc(
            accountDataSource: get<AccountDataSource>("AccountDataSource"),
            googleSignIn: get<GoogleSignIn>("GoogleSignIn")),
        name: "SignBloc",
        defaultMode: dioc.InjectMode.create);

    _container.register<PublicationBloc>(
        (c) => PublicationBloc(
            accountDataSource: get<AccountDataSource>("AccountDataSource"),
            publicationDataSource:
                get<PublicationDataSource>("PublicationDataSource")),
        name: "PublicationBloc",
        defaultMode: dioc.InjectMode.create);
  }
}
