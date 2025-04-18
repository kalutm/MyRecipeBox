import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';
import 'package:my_recipe_box/views/recipe_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        final currentUser = snapshot.data;
          if(currentUser == null) {
            return LoginView();
            }
          else if(!currentUser.emailVerified) {
            return EmailVerificationView();
          }
          return RecipeListView();
        default:
        return spinkitRotatingCircle;
      }
    },);
  }
}