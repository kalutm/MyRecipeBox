import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/utils/call_backs.dart';
import 'package:my_recipe_box/utils/constants/colors.dart'; // While we have theme, keeping this for specific colors if needed
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:my_recipe_box/utils/constants/view_constants.dart';
import 'package:my_recipe_box/widgets/sized_box.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';

class DetailedRecipeView extends StatefulWidget {
  final Recipe recipe;
  final RecipeCallback onUpdate;
  final RecipeCallback onUpdateFavorite;
  const DetailedRecipeView({
    super.key,
    required this.recipe,
    required this.onUpdate,
    required this.onUpdateFavorite,
  });

  @override
  State<DetailedRecipeView> createState() => _DetailedRecipeViewState();
}

class _DetailedRecipeViewState extends State<DetailedRecipeView> {
  late bool isFavoriteSelected;

  @override
  void initState() {
    isFavoriteSelected = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe.title,
          style:
              theme.appBarTheme.titleTextStyle, // Use titleTextStyle from theme
        ),
        backgroundColor:
            theme.appBarTheme.backgroundColor, // Use backgroundColor from theme
        iconTheme: theme.appBarTheme.iconTheme, // Use iconTheme from theme
        actions: [
          IconButton(
            onPressed: () => widget.onUpdate(widget.recipe),
            icon: const Icon(Icons.edit),
            color:
                theme.appBarTheme.iconTheme?.color, // Use icon color from theme
          ),
          IconButton(
            icon: Icon(
              isFavoriteSelected ? Icons.favorite : Icons.favorite_border,
              color: Colors.white, // Keep specific color
            ),
            onPressed: () {
              widget.onUpdateFavorite(widget.recipe);
              setState(() => isFavoriteSelected = !isFavoriteSelected);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Photo
            if (widget.recipe.photoPath != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    File(widget.recipe.photoPath!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 240.0,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 240.0,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 72.0,
                          color: theme.hintColor,
                        ), // Use hintColor
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                height: 240.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[300],
                ),
                child: Icon(
                  Icons.local_pizza,
                  size: 72.0,
                  color: theme.hintColor,
                ), // Use hintColor
              ),
            sizedBoxHieght16,

            // Category
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: theme.colorScheme.secondary,
                ), // Use secondary color
                const SizedBox(width: 8.0),
                Text(
                  widget.recipe.category ?? notSetString,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ), // Use secondary color
                ),
              ],
            ),
            sizedBoxHieght24,

            // Ingredients
            Text(
              ingredientsCoulmn.toUpperCase(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
              ), // Use primaryColor
            ),
            sizedBoxHieght8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  widget.recipe.ingredients.map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: theme.primaryColor,
                          ), // Use primaryColor
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            sizedBoxHieght24,

            // Steps
            Text(
              stepsCoulmn.toUpperCase(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
              ), // Use primaryColor
            ),
            sizedBoxHieght8,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.recipe.steps.length,
              separatorBuilder: (context, index) => const Divider(height: 20.0),
              itemBuilder: (context, index) {
                final stepNumber = index + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        radius: 16.0,
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          widget.recipe.steps[index],
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            sizedBoxHieght24,
          ],
        ),
      ),
    );
  }
}
