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
  final bool isGridView; // New parameter to control layout

  const RecipeList({
    super.key,
    required this.recipes,
    required this.onDeleteRecipe,
    required this.onUpdateRecipe,
    required this.onUpdateFavorite,
    this.isGridView = true, // Default to grid view
  });

  Widget _buildListItem(BuildContext context, int index) {
    final recipe = recipes[index];
    return Card(
      elevation: 2.0, // Add a subtle shadow
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // Add some spacing around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), // Rounded corners
      child: InkWell(
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
        child: Padding(
          padding: const EdgeInsets.all(
            12.0,
          ), // Add padding inside the ListTile
          child: Row(
            children: [
              // Enhanced Leading Image/Icon
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300], // Placeholder background
                ),
                child:
                    recipe.photoPath == null
                        ? const Icon(
                          Icons.local_pizza,
                          size: 40.0,
                          color: Colors.grey,
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(recipe.photoPath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 40.0,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
              ),
              const SizedBox(width: 16.0),
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (recipe.category != null)
                      Text(
                        recipe.category!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // Favorite Icon
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: () => onUpdateFavorite(recipe),
              ),
              // Delete Icon
              IconButton(
                onPressed: () => onDeleteRecipe(recipe),
                icon: const Icon(Icons.delete, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
  final recipe = recipes[index];
  return Card(
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedRecipeView(
            recipe: recipe,
            onUpdate: onUpdateRecipe,
            onUpdateFavorite: onUpdateFavorite,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: recipe.photoPath == null
                ? const Icon(Icons.local_pizza, size: 60)
                : Image.file(
                    File(recipe.photoPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 60,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                if (recipe.category != null)
                  Text(
                    recipe.category!,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align icons to the end
                  children: [
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => onUpdateFavorite(recipe),
                    ),
                    IconButton(
                      onPressed: () => onDeleteRecipe(recipe),
                      icon: const Icon(Icons.delete, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // You can adjust the number of columns
          childAspectRatio: 0.8,
        ),
        itemBuilder: _buildGridItem,
        itemCount: recipes.length,
        padding: const EdgeInsets.all(8.0),
      );
    } else {
      return ListView.builder(
        itemBuilder: _buildListItem,
        itemCount: recipes.length,
      );
    }
  }
}
