import 'package:my_recipe_box/services/auth/auth_interface.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/services/auth/firebase_auth.dart';

class AuthService implements AuthInterface {
  final AuthInterface someAuth;

  const AuthService({required this.someAuth});

  factory AuthService.fireAuth() {
    return AuthService(someAuth: FireAuth());
  }

  @override
  Stream<AuthUser?> authUserState() => someAuth.authUserState();

  @override
  AuthUser? get currentUser => someAuth.currentUser;

  @override
  Future<void> initializeApp() => someAuth.initializeApp();

  @override
  Future<AuthUser> login(String email, String password) =>
      someAuth.login(email, password);

  @override
  Future<void> logout() => someAuth.logout();

  @override
  Future<AuthUser> register(String email, String password) =>
      someAuth.register(email, password);
  @override
  Future<void> sendVerificationEmail() => someAuth.sendVerificationEmail();
  
}
