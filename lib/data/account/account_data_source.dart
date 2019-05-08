import 'package:google_sign_in/google_sign_in.dart';
import 'package:res_publica/model/user_entity.dart';

abstract class AccountDataSource {
  Future<UserEntity> register(String name, String email, String password);

  Future<UserEntity> signIn(String email, String password);

  Future<void> resetPassword(String email);

  Future<UserEntity> updatePassword(String oldPassword, String newPassword);

  Future<UserEntity> updateAccount(UserEntity user);

  Future<void> signOut();

  Future<UserEntity> signInWithGoogle(GoogleSignInAccount currentUser);

  Future<UserEntity> get currentUser;

  Future<bool> hasEmailAccount(String text);
}
