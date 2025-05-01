import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/models/recipe_user.dart';

typedef SetAsCurrentUser = Future<void> Function(RecipeUser recipeUser);
typedef RecipeCallback = void Function(Recipe recipe);
typedef OnUpdateThemeCallback = void Function(bool isDark);
typedef OnUpdateDefaultViewCallback = void Function(String view);
