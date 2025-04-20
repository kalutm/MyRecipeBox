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

  Recipe.fromRowMap(Map<String, Object?> dbRowMap)
    : id = dbRowMap[recipeIdCoulmn] as String,
      userId = dbRowMap[userIdCoulmn] as String,
      title = dbRowMap[titleCoulmn] as String,
      ingredients = List<String>.from(
  jsonDecode(dbRowMap[ingredientsCoulmn] as String)
),
      steps = List<String>.from(
        jsonDecode(dbRowMap[stepsCoulmn] as String)
      ),
      category = dbRowMap[categoryCoulmn] = dbRowMap[photoPathCoulmn] == null ? null: dbRowMap[photoPathCoulmn] as String,
      photoPath =
          dbRowMap[photoPathCoulmn] == null
              ? null
              : dbRowMap[photoPathCoulmn] as String,
      isFavorite = dbRowMap[isFavoritecoulmn] == 1;

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
