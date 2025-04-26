import 'package:flutter/material.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/views/recipes/recipe_view.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrapping with Scaffold for consistent background
      body: StreamBuilder(
        stream: AuthService.fireAuth().authUserState(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              final currentUser = snapshot.data;
              if (currentUser == null) {
                return const LoginView(); // Ensure const for performance
              } else if (!currentUser.isEmailVerified) {
                return const EmailVerificationView(); // Ensure const for performance
              }
              return const RecipeView(); // Ensure const for performance
            default:
              return const Center(
                child: spinkitRotatingCircle,
              ); // Center the loading indicator
          }
        },
      ),
    );
  }
}
