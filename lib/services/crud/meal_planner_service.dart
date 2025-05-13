import 'dart:async';
import 'dart:convert';
import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/models/meal_plan.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/models/recipe_user.dart';
import 'package:my_recipe_box/services/crud/database_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev_tool show log;

class MealPlannerService {
  final DatabaseService _databaseService = DatabaseService();
  RecipeUser? _currentUser;
  List<MealPlan> allMealPlans = [];

  MealPlannerService._instance();
  static final MealPlannerService _cachedInstance =
      MealPlannerService._instance();
  factory MealPlannerService() {
    return _cachedInstance;
  }

  Future<List<MealPlan>> get getAllUserMealPlans async {
    final currentUser = _currentUser;
    if(currentUser == null){
      throw UserShouldBeSetBeforeReadingMealPlans();
    }
    await _cacheAllMealPlans();
    return allMealPlans.where((mealPlan) => mealPlan.userId == currentUser.id).toList();
  }

  Future<void> setCurrentUser(RecipeUser user) async {
    _currentUser = user;
    try {
      await _cacheAllMealPlans();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<void> createMealPlan({required MealPlan mealPlan}) async {
    try {
      final database = await _databaseService.database;
      final id = await database.insert(mealPlanTable, mealPlan.toMap());

      if (id == 0) {
        throw CouldNotCreateMealPlanCrudException();
      }
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<MealPlan> getMealPlan({required int id}) async {
    try {
      final database = await _databaseService.database;
      final mealPlans = await database.query(
        mealPlanTable,
        limit: 1,
        where: "$mealIdCoulmn = ?",
        whereArgs: [id]
      );

      if (mealPlans.isEmpty) {
        throw CouldNotFindMealPlanCrudException();
      }

      return MealPlan.fromRowMap(mealPlans.first);

    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  _cacheAllMealPlans() async {
    final allMeals = await getAllMealPlans();
    allMealPlans = allMeals;
  }

  Future<List<MealPlan>> getAllMealPlans() async {
    try {
      final database = await _databaseService.database;
      final mealPlans = await database.query(mealPlanTable);
      dev_tool.log(mealPlans.runtimeType.toString());

      return mealPlans
          .map((recipeRowMap) => MealPlan.fromRowMap(recipeRowMap))
          .toList();

    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }
}
