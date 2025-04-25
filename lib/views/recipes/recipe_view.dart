import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/services/crud/recipe_user_service.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:my_recipe_box/utils/constants/enums/recipe_view_actions_enum.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/logout_dialog.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_list_view.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool isFavoriteList = false;

  late Future<void> _recipeUserFuture;

  late Stream<List<Recipe>> _favoriteRecipeStream;
  late Stream<List<Recipe>> _recipeStream;

  late RecipeService _recipeService;
  late RecipeUserService _recipeUserService;

  Future<void> _createOrGetUser() async {
    await _recipeUserService.createOrGetUser(
      email: currentUser.email!,
      setUser: (recipeUser) async {
        await _recipeService.setCurrentUser(recipeUser);
      },
    );
  }

  @override
  initState() {
    _recipeService = RecipeService();
    _recipeUserService = RecipeUserService();
    _favoriteRecipeStream = _recipeService.favoriteRecipeStream;
    _recipeStream = _recipeService.recipeStream;

    _recipeUserFuture = _createOrGetUser();
    super.initState();
  }

  AuthUser get currentUser {
    return AuthService.fireAuth().currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isFavoriteList ? favoriteRecipesTextWidget : recipesTextWidget,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isFavoriteList = !isFavoriteList);
            },
            icon: Icon(
              isFavoriteList ? Icons.star : Icons.star_border,
              color: Colors.amberAccent,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateUpdateRecipeView(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return Settings.values.map((items) {
                return PopupMenuItem(
                  value: items.name,
                  child: Text(items.name),
                  onTap: () async {
                    switch (items) {
                      case Settings.logout:
                        final reponse = await showLogoutDialog(
                          context: context,
                        );
                        if (reponse) {
                          await AuthService.fireAuth().logout();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              loginViewRoute,
                              (route) => false,
                            );
                          }
                        }
                        break;
                      default:
                        break;
                    }
                  },
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _recipeUserFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error!.toString()));
              }
              return StreamBuilder(
                stream: isFavoriteList ? _favoriteRecipeStream : _recipeStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error!.toString()));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: noRecipesYetTextWidget);
                      }
                      final recipes = snapshot.data!;
                      return RecipeList(
                        recipes: recipes,
                        onDeleteRecipe: (recipe) async {
                          await _recipeService.deleteRecipe(id: recipe.id);
                        },
                        onUpdateRecipe:
                            (recipe) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        CreateUpdateRecipeView(recipe: recipe),
                              ),
                            ),
                        onUpdateFavorite: (recipe) async {
                          await _recipeService.updataRecipeCoulmn(
                            id: recipe.id,
                            coulmn: isFavoritecoulmn,
                            newValue: recipe.isFavorite ? 0 : 1,
                          );
                        },
                      );

                    default:
                      return spinkitRotatingCircle;
                  }
                },
              );

            default:
              return spinkitRotatingCircle;
          }
        },
      ),
    );
  }
}
