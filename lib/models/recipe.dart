import 'dart:convert';

import 'package:my_recipe_box/utils/constants/databas_constants.dart';

class Recipe {
  final String id;
  final String userId;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String? category;
  final String? photoPath;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.ingredients,
    required this.steps,
    this.category,
    this.photoPath,
    this.isFavorite = false,
  });

  Recipe.fromMap(Map<String, Object?> dbRow)
    : id = dbRow[recipeIdCoulmn] as String,
      userId = dbRow[userIdCoulmn] as String,
      title = dbRow[titleCoulmn] as String,
      ingredients = List<String>.from(
  jsonDecode(dbRow[ingredientsCoulmn] as String)
),
      steps = List<String>.from(
        jsonDecode(dbRow[stepsCoulmn] as String)
      ),
      category = dbRow[categoryCoulmn] = dbRow[photoPathCoulmn] == null ? null: dbRow[photoPathCoulmn] as String,
      photoPath =
          dbRow[photoPathCoulmn] == null
              ? null
              : dbRow[photoPathCoulmn] as String,
      isFavorite = dbRow[isFavoritecoulmn] == 1;

  Map<String, Object?> toMap(){
    return {
      recipeIdCoulmn: id,
      userIdCoulmn: userId,
      titleCoulmn: title,
      ingredientsCoulmn: jsonEncode(ingredients),
      stepsCoulmn: jsonEncode(steps),
      categoryCoulmn: category,
      photoPathCoulmn: photoPath,
      isFavoritecoulmn: isFavorite ? 1 : 0,

    };
  }

  @override
  String toString() => "title: $title";

  @override
  bool operator ==(covariant Recipe other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
