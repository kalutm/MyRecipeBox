import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/utils/call_backs.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final RecipeCallback onDeleteRecipe;
  final RecipeCallback onUpdateRecipe;

  const RecipeList({
    super.key,
    required this.recipes,
    required this.onDeleteRecipe,
    required this.onUpdateRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
