import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/views/auth/auth_wrapper.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';
import 'package:my_recipe_box/views/auth/register_view.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyRecipeBox());
}

class MyRecipeBox extends StatelessWidget {
  const MyRecipeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: authWrapperRoute,
      routes: {
        authWrapperRoute: (context) => const AuthWrapper(),
        loginViewRoute: (context) => const LoginView(),
        registerViewRoute: (context) => const RegisterView(),
        emailVerificationRoute: (context) => const EmailVerificationView(),
        recipeViewRoute: (context) => const RecipeView(),
        createUpdateRecipeViewRoute:
            (context) => const CreateUpdateRecipeView(),
      },
      theme: ThemeData(
        // Define the color scheme based on a primary color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        // Use the color scheme for visual elements
        primaryColor: Colors.deepOrange,
        hintColor: Colors.grey[600],
        scaffoldBackgroundColor:
            Colors.grey[50], // Light background for the body
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[700],
          ),
          bodyMedium: const TextStyle(fontSize: 16.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 4, // Add a subtle shadow
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepOrange!),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
