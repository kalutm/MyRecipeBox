import 'package:my_recipe_box/services/auth/auth_user.dart';

abstract class AuthInterface {
  AuthUser? get currentUser;

  Stream<AuthUser?> authUserState();
  Future<AuthUser> login(String email, String password);
  Future<void> logout();
  Future<AuthUser> register(String email, String password);
  Future<bool> startEmailVerificationCheck();
  Future<void> sendVerificationEmail();
  Future<void> initializeApp();
}