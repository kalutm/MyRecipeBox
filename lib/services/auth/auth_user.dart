import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String? email;
  final bool isEmailVerified;

  const AuthUser({required this.email, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User currentUser){
    return AuthUser(
      email: currentUser.email, 
      isEmailVerified: currentUser.emailVerified
      );
  }
}
