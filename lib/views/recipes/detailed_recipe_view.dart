import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/utils/call_backs.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: detailedRecipeTextWidget,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () => widget.onUpdate(widget.recipe),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            icon: Icon(
              isFavoriteSelected ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              widget.onUpdateFavorite(widget.recipe);
              setState(() => isFavoriteSelected = !isFavoriteSelected);
            },
            color: Colors.yellowAccent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$titleCoulmn: ${widget.recipe.title}"),
            sizedBoxHieght8,
            widget.recipe.photoPath == null
                ? Icon(Icons.local_pizza)
                : Image.file(File(widget.recipe.photoPath!)),
            sizedBoxHieght8,
            Text("$categoryCoulmn: ${widget.recipe.category ?? notSetString}"),
            sizedBoxHieght8,
            Text(ingredientsCoulmn),
            ...widget.recipe.ingredients.map((ingredient) => Text(ingredient)),
            sizedBoxHieght8,
            Text(stepsCoulmn),
            ...widget.recipe.steps.map((step) => Text(step)),
          ],
        ),
      ),
    );
  }
}
