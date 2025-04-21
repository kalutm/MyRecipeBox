import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/crud/database_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev_tool show log;

class RecipeService {
  final databaseService = DatabaseService();

  Future<Recipe> createRecipe({required int userId}) async {
    try {
      final database = await databaseService.database;
      final recipe = Recipe(userId: userId);

      final id = await database.insert(recipeTable, recipe.toMap());

      if (id == 0) {
        throw CouldNotCreateRecipeCrudException();
      }
      return Recipe(id: id, userId: userId);
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<Recipe> getRecipe({required int id}) async {
    try {
      final database = await databaseService.database;

      final recipes = await database.query(
        recipeTable,
        limit: 1,
        where: "$idCoulmn = ?",
        whereArgs: [id],
      );

      if (recipes.isEmpty) {
        throw CouldNotFindRcipeCrudException();
      }
      final recipeRowMap = recipes.first;

      return Recipe.fromRowMap(recipeRowMap);
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    try {
      final database = await databaseService.database;
      final recipes = await database.query(recipeTable);

      return recipes
          .map((recipeRowMap) => Recipe.fromRowMap(recipeRowMap))
          .toList();
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<List<Recipe>> getUserRecipes({required int userId}) async {
    try {
      final database = await databaseService.database;
      final recipes = await database.query(
        recipeTable,
        where: "$userIdCoulmn = ?",
        whereArgs: [userId],
      );

      return recipes
          .map((recipeRowMap) => Recipe.fromRowMap(recipeRowMap))
          .toList();
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<List<Recipe>> getUserFavoriteRecipes({required int userId}) async {
    try {
      final database = await databaseService.database;
      final userRecipes = await getUserRecipes(userId: userId);

      return userRecipes
          .where((recipeRowMap) => recipeRowMap.isFavorite == true)
          .toList();
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<void> updataRecipeCoulmn({
    required int id,
    required String coulmn,
    required Object? newValue,
  }) async {
    try {
      if (!allowedCoulmns.contains(coulmn)) {
        throw NoSuchRecipeCoulmnCrudException();
      }

      await getRecipe(id: id);

      final database = await databaseService.database;

      final updateCount = await database.update(
        recipeTable,
        where: "$idCoulmn = ?",
        whereArgs: [id],
        {coulmn: newValue},
      );

      if (updateCount == 0) {
        CouldNotUpdateRecipeCrudException();
      }
    } on CouldNotFindRcipeCrudException {
      rethrow;
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<void> deleteRecipe({required int id}) async {
    try {
      final database = await databaseService.database;

      await getRecipe(id: id);

      final deletCount = await database.delete(
        recipeTable,
        where: "$idCoulmn = ?",
        whereArgs: [id],
      );

      if (deletCount == 0) {
        throw CouldNotDeleteRecipeCrudException();
      }
    } on CouldNotFindRcipeCrudException {
      rethrow;
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<int> deleteAllRecipes() async {
    try {
      final database = await databaseService.database;

      return await database.delete(recipeTable);
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }
}
