import 'package:my_recipe_box/utils/constants/databas_constants.dart';

class MealPlan {
  int? id;
  int userId;
  int recipeId;
  DateTime date;
  String mealType; // e.g., "Breakfast", "Lunch", "Dinner", "Snack"
   // The selected recipe for this meal

  MealPlan({required this.id, required this.userId, required this.date, required this.mealType, required this.recipeId});

  MealPlan.fromRowMap(Map<String, Object?> dbRowMap)
  : id = dbRowMap[mealIdCoulmn] as int,
    userId = dbRowMap[mealUserIdCoulmn] as int,
    recipeId = dbRowMap[mealRecipeIdCoulmn] as int,
    date = DateTime.parse(dbRowMap[mealDateCoulmn] as String) ,
    mealType = dbRowMap[mealTypeCoulmn] as String ;


    Map<String, Object?> toMap() {
    return {
      mealIdCoulmn: id,
      mealUserIdCoulmn: userId,
      mealRecipeIdCoulmn: recipeId,
      mealDateCoulmn: date.toIso8601String(),
      mealTypeCoulmn: mealType,
    };
  }

}