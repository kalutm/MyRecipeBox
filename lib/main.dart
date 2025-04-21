import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/views/auth/auth_wrapper.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';
import 'package:my_recipe_box/views/auth/register_view.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/detailed_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_list_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyRecipeBox());
}

class MyRecipeBox extends StatelessWidget {
  const MyRecipeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: authWrapperRoute,
      routes: {
        authWrapperRoute: (context) => AuthWrapper(),
        loginViewRoute: (context) => LoginView(),
        registerViewRoute: (context) => RegisterView(),
        emailVerificationRoute: (context) => EmailVerificationView(),
        recipeViewRoute: (context) => RecipeView(),
        recipeListViewRoute: (context) => RecipeListView(),
        detailedRecipeView: (context) => DetailedRecipeView(),
        createUpdateRecipeView: (context) => CreateUpdateRecipeView(),
      },
    );
  }
}
