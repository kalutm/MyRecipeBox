import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/utils/call_backs.dart';
import 'package:my_recipe_box/views/recipes/detailed_recipe_view.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final RecipeCallback onDeleteRecipe;
  final RecipeCallback onUpdateRecipe;
  final RecipeCallback onUpdateFavorite;

  const RecipeList({
    super.key,
    required this.recipes,
    required this.onDeleteRecipe,
    required this.onUpdateRecipe,
    required this.onUpdateFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          child: ListTile(
            leading:
                recipe.photoPath == null
                    ? Icon(Icons.local_pizza)
                    : Image.file(File(recipe.photoPath!)),
            title: Text(recipe.title),
            subtitle: recipe.category == null ? null : Text(recipe.category!),
            trailing: IconButton(
              onPressed: () => onDeleteRecipe(recipe),
              icon: Icon(Icons.delete),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailedRecipeView(
                          recipe: recipe,
                          onUpdate: onUpdateRecipe,
                          onUpdateFavorite: onUpdateFavorite,
                        ),
                  ),
                ),
          ),
        );
      },
      itemCount: recipes.length,
    );
  }
}
