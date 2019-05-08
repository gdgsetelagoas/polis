import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/model/user_entity.dart';

class FirebaseAccountDataSource implements AccountDataSource {
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;
  final FirebaseStorage firebaseStorage;

  FirebaseAccountDataSource({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.firebaseStorage,
  });

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }

  @override
  Future<UserEntity> register(String name, String email, String password) {
    return firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .asStream()
        .map((fUser) {
      fUser.updateProfile(UserUpdateInfo()..displayName = name);
      return _adapterFirebaseUserToUser(fUser);
    }).first;
  }

  @override
  Future<void> resetPassword(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    var fUser = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _adapterFirebaseUserToUser(fUser);
  }

  @override
  Future<UserEntity> updateAccount(UserEntity user) async {
    var fUserTemp = await firebaseAuth.currentUser().then((fuser) {
      fuser.updateProfile(UserUpdateInfo()
        ..displayName = user.name
        ..photoUrl = user.photo);
    });
    return _adapterFirebaseUserToUser(fUserTemp);
  }

  @override
  Future<UserEntity> updatePassword(
      String oldPassword, String newPassword) async {
    var user = await firebaseAuth.currentUser();
    await user.updatePassword(newPassword);
    return _adapterFirebaseUserToUser(user);
  }

  UserEntity _adapterFirebaseUserToUser(FirebaseUser fUser) {
    if (fUser == null) return null;
    var user = UserEntity();
    user
      ..userId = fUser.uid
      ..name = fUser.displayName
      ..email = fUser.email
      ..photo = fUser.photoUrl
      ..createdAt =
          DateTime.fromMillisecondsSinceEpoch(fUser.metadata.creationTimestamp)
              .toIso8601String();
    return user;
  }

  @override
  Future<UserEntity> signInWithGoogle(GoogleSignInAccount currentUser) async {
    var userGoogleAuthentication = await currentUser.authentication;
    var user = _adapterFirebaseUserToUser(await firebaseAuth.linkWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: userGoogleAuthentication.idToken,
            accessToken: userGoogleAuthentication.accessToken)));
    return user;
  }

  @override
  Future<UserEntity> get currentUser async {
    var u = await firebaseAuth.currentUser();
    return _adapterFirebaseUserToUser(u);
  }

  @override
  Future<bool> hasEmailAccount(String text) async {
    return null;
  }
}
