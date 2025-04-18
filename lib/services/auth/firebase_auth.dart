import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_recipe_box/services/auth/auth_interface.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';

class FireAuth implements AuthInterface{
  @override
  AuthUser? get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

  @override
  Stream<AuthUser?> authUserStream() {
    final Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
    return userStream.map((currentUser) {
      if(currentUser != null){
        return AuthUser.fromFirebase(currentUser);
      }
      return null;
    } );
  }

  @override
  Future<void> initializeApp() {
    // TODO: implement initializeApp
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> sendVerificationEmail() {
    // TODO: implement sendVerificationEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> startEmailVerificationCheck() {
    // TODO: implement startEmailVerificationCheck
    throw UnimplementedError();
  }
  

}