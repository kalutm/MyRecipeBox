import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_recipe_box/exceptions/auth/auth_exceptions.dart';
import 'package:my_recipe_box/firebase_options.dart';
import 'package:my_recipe_box/services/auth/auth_interface.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'dart:developer' as dev_tool show log;

class FireAuth implements AuthInterface {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

  @override
  Stream<AuthUser?> authUserState() {
    final Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
    return userStream.map((currentUser) {
      if (currentUser != null) {
        return AuthUser.fromFirebase(currentUser);
      }
      return null;
    });
  }

  @override
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      dev_tool.log(userCredential.toString());
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return AuthUser.fromFirebase(currentUser);
      }
      throw CouldNotLogUserInAuthException();
    } on FirebaseAuthException catch (authError) {
      if (authError.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else if (authError.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (authError.code == "invalid-credential" ||
          authError.code == "wrong-password") {
        throw WrongPasswordAuthException();
      } else if (authError.code == "network-request-failed") {
        throw NetworkErrorAuthException();
      }
      dev_tool.log(authError.toString());
      throw AuthException();
    } catch (authError) {
      dev_tool.log(authError.toString());
      throw AuthException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw UserAlreadyLoggedOutAuthException();
      }
      await FirebaseAuth.instance.signOut();
    } catch (authError) {
      dev_tool.log(authError.toString());
      throw LogginOutAuthException();
    }
  }

  @override
  Future<AuthUser> register(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      dev_tool.log(userCredential.toString());

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return AuthUser.fromFirebase(currentUser);
      }
      throw CouldNotLogUserInAuthException();
    } on FirebaseAuthException catch (authError) {
      if (authError.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (authError.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else if (authError.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else if (authError.code == "network-request-failed") {
        throw NetworkErrorAuthException();
      }
      dev_tool.log(authError.toString());
      throw AuthException();
    } catch (authError) {
      dev_tool.log(authError.toString());
      throw AuthException();
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.sendEmailVerification();
      }
      else{
        throw UserNotLoggedInAuthException();
      }
    } on UserNotLoggedInAuthException{
      rethrow;
    }
    catch (authError) {
      dev_tool.log(authError.toString());
      throw VerificationSendingAuthException();
    }
  }

  @override
  Future<bool> startEmailVerificationCheck() async {
    try {
      final completer = Completer<bool>();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw UserNotLoggedInAuthException();
      }

      Timer timeoutTimer = Timer(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException("Email verification timed out after 60 seconds"),
          );
        }
      });

      Timer.periodic(const Duration(seconds: 2), (timer) async {
        try {
          await user.reload();
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null && currentUser.emailVerified) {
            timer.cancel();
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          }
        } catch (e, stackTrace) {
          timer.cancel();
          timeoutTimer.cancel();
          if (!completer.isCompleted) {
            completer.completeError(e, stackTrace);
          }
        }
      });

      return await completer.future;
    } catch (authError) {
      if (authError is TimeoutException) {
        throw EmailVerificationCheckTimeoutException();
      }
      throw EmailVerificationCheckAuthException();
    }
  }
}
