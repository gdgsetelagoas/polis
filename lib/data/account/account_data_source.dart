import 'package:google_sign_in/google_sign_in.dart';
import 'package:res_publica/model/request_response.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class AccountDataSource {
  Future<RequestResponse<UserEntity>> register(UserEntity user);

  Future<RequestResponse<UserEntity>> signIn(String email, String password);

  Future<RequestResponse> resetPassword(String email);

  Future<RequestResponse<UserEntity>> updatePassword(
      String oldPassword, String newPassword);

  Future<RequestResponse<UserEntity>> updateAccount(UserEntity user);

  Future<RequestResponse> signOut();

  Future<RequestResponse<UserEntity>> signInWithGoogle(
      GoogleSignInAccount currentUser);

  Future<UserEntity> get currentUser;

  UserEntity get user;

  Future<RequestResponse<bool>> hasEmailAccount(String text);

  Stream<UserEntity> onAuthStateChange();

  Future<UserEntity> getUserById(String userId);
}
