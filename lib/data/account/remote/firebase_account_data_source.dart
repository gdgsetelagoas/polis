import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/util/errors.dart';
import 'package:res_publica/model/request_response.dart';
import 'package:res_publica/model/user_entity.dart';

class FirebaseAccountDataSource implements AccountDataSource {
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;
  final FirebaseStorage firebaseStorage;
  UserEntity _user;

  FirebaseAccountDataSource({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.firebaseStorage,
  }) {
    currentUser;
  }

  @override
  Future<RequestResponse> signOut() async {
    try {
      await firebaseAuth.signOut();
      return RequestResponse.success(null);
    } catch (e) {
      return errorFirebase(e, 400);
    }
  }

  @override
  Future<RequestResponse<UserEntity>> register(UserEntity user) async {
    try {
      var tUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      tUser.updateProfile(UserUpdateInfo()..displayName = user.name);
      _user = _adapterFirebaseUserToUser(tUser);
      return RequestResponse<UserEntity>.success(_user);
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<RequestResponse> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return RequestResponse.success(null);
    } catch (e) {
      return errorFirebase(e, 400);
    }
  }

  @override
  Future<RequestResponse<UserEntity>> signIn(
      String email, String password) async {
    try {
      var fUser = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = _adapterFirebaseUserToUser(fUser);
      return RequestResponse<UserEntity>.success(_user);
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<RequestResponse<UserEntity>> updateAccount(UserEntity user) async {
    try {
      var fUserTemp = await firebaseAuth.currentUser().then((fuser) {
        fuser.updateProfile(UserUpdateInfo()
          ..displayName = user.name
          ..photoUrl = user.photo);
      });
      return RequestResponse<UserEntity>.success(
          _adapterFirebaseUserToUser(fUserTemp));
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<RequestResponse<UserEntity>> updatePassword(
      String oldPassword, String newPassword) async {
    try {
      var user = await firebaseAuth.currentUser();
      await user.updatePassword(newPassword);
      return RequestResponse<UserEntity>.success(
          _adapterFirebaseUserToUser(user));
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
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
  Future<RequestResponse<UserEntity>> signInWithGoogle(
      GoogleSignInAccount currentUser) async {
    try {
      var userGoogleAuthentication = await currentUser.authentication;
      var user = _adapterFirebaseUserToUser(await firebaseAuth
          .signInWithCredential(GoogleAuthProvider.getCredential(
              idToken: userGoogleAuthentication.idToken,
              accessToken: userGoogleAuthentication.accessToken)));
      return RequestResponse<UserEntity>.success(user);
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<UserEntity> get currentUser async {
    var u = await firebaseAuth.currentUser();
    _user = _adapterFirebaseUserToUser(u);
    return _user;
  }

  @override
  UserEntity get user => _user;

  @override
  Future<RequestResponse<bool>> hasEmailAccount(String text) async {
    return null;
  }

  @override
  Stream<UserEntity> onAuthStateChange() {
    return firebaseAuth.onAuthStateChanged.map(_adapterFirebaseUserToUser);
  }
}
