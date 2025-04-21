import 'package:flutter/material.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_list_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.fireAuth().authUserState(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            final currentUser = snapshot.data;
            if (currentUser == null) {
              return LoginView();
            } else if (!currentUser.isEmailVerified) {
              return EmailVerificationView();
            }
            return RecipeListView();
          default:
            return spinkitRotatingCircle;
        }
      },
    );
  }
}
