import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/data/util/errors.dart';
import 'package:res_publica/model/request_response.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/utils/patterns.dart';

class FirebaseAccountDataSource implements AccountDataSource {
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;
  final FirebaseStorage firebaseStorage;
  UserEntity _user;
  final Map<String, UserEntity> _users = {};

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
      var _userT = _adapterFirebaseUserToUser(tUser);
      await firestore
          .collection("users")
          .document(tUser.uid)
          .setData(user.toJson()..remove("password"));

      return RequestResponse<UserEntity>.success(_userT);
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
      var userDoc =
          await firestore.collection("users").document(fUser.uid).get();
      _user = UserEntity.fromJson(userDoc.data);
      return RequestResponse<UserEntity>.success(_user);
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<RequestResponse<UserEntity>> updateAccount(UserEntity user) async {
    var photo = user.photo;
    try {
      if (!isHttp.hasMatch(user.photo)) {
        var task = await firebaseStorage
            .ref()
            .child('profile/${user.userId}.jpg')
            .putFile(File(user.photo))
            .onComplete;
        photo = await task.ref.getDownloadURL();
      }
      var fUserTemp = await firebaseAuth.currentUser();
      fUserTemp.updateProfile(UserUpdateInfo()
        ..displayName = user.name
        ..photoUrl = photo);
      await firestore.collection("users").document(user.userId).setData(
          _adapterFirebaseUserToUser(fUserTemp).toJson()..remove("password"),
          merge: true);
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
      ..photo = fUser.photoUrl;
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
      await firestore
          .collection("users")
          .document(user.userId)
          .setData(user.toJson());
      return RequestResponse<UserEntity>.success(user);
    } catch (e) {
      return errorFirebase<UserEntity>(e, 400);
    }
  }

  @override
  Future<UserEntity> get currentUser async {
    if (_user == null) {
      var u = await firebaseAuth.currentUser();
      var userDoc = await firestore.collection("users").document(u.uid).get();
      _user = UserEntity.fromJson(userDoc.data);
    }
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
    return firebaseAuth.onAuthStateChanged
        .asyncMap<UserEntity>((firebaseUser) async {
      if (firebaseUser == null)
        return null;
      else
        return await currentUser;
    });
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    if (_users.containsKey(userId)) return _users[userId];
    var doc = await firestore.collection("users").document(userId).get();
    if (doc.exists) {
      _users[userId] = UserEntity.fromJson(doc.data);
      return _users[userId];
    }
    return UserEntity(name: "Desconhecido", photo: "");
  }
}
