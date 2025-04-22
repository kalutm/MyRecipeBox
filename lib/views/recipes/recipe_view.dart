import 'package:flutter/material.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/services/crud/recipe_user_service.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
import 'package:my_recipe_box/utils/constants/enums/recipe_view_actions_enum.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/logout_dialog.dart';
import 'package:my_recipe_box/views/recipes/recipe_list_view.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late RecipeService _recipeService;
  late RecipeUserService _recipeUserService;

  @override
  initState(){
    _recipeService = RecipeService();
    _recipeUserService = RecipeUserService();
    super.initState();
  }

  AuthUser get currentUser{
    return AuthService.fireAuth().currentUser!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: recipesTextWidget,
        backgroundColor: appBarColor,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return Settings.values.map((items){
                return PopupMenuItem(
                  value: items.name,
                  child: Text(items.name),
                  onTap: () async {
                    switch (items) {
                      case Settings.logout:
                        final reponse = await showLogoutDialog(context: context);
                        if(reponse) {
                          await AuthService.fireAuth().logout();
                          if(context.mounted) Navigator.pushNamedAndRemoveUntil(context, loginViewRoute, (route) => false);
                        }
                        break;
                      default:
                       break;
                    }
                  },
                  );
              }).toList();
            },
            )
        ],
      ),
      body: FutureBuilder(
        future: _recipeUserService.createOrGetUser(
          email: currentUser.email!,
          setUser: (recipeUser) async {
            _recipeService.setCurrentUser(recipeUser);
            }
          ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error!.toString()));
              }
              return StreamBuilder(
                stream: _recipeService.recipeStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if(snapshot.hasError){
                        return Center(child: Text(snapshot.error!.toString()));
                      }
                      else if(!snapshot.hasData || snapshot.data!.isEmpty){
                        return Center(child: noRecipesYetTextWidget);
                      }
                      final recipes = snapshot.data!;
                      return RecipeList(
                          recipes: recipes,
                          onDeleteRecipe: (recipe) async {
                            await _notesService.deleteNote(id: recipe.id);
                          },
                          onUpdateRecipe: (recipe) => Navigator.of(context).pushNamed(createUpdateRecipeViewRoute, arguments: recipe),
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
