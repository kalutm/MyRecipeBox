import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/models/recipe_user.dart';
import 'package:my_recipe_box/services/crud/database_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'dart:developer' as dev_tool show log;

import 'package:sqflite/sqflite.dart';

class RecipeUserService {
  final databaseService = DatabaseService();

  Future<RecipeUser> createUser({required String email}) async {
    try {
      final database = await databaseService.database;

      final recipeUsers = await database.query(
        userTable,
        limit: 1,
        where: "$emailCoulmn = ?",
        whereArgs: [email.toLowerCase()],
      );

      final id = await database.insert(userTable, {"email": email});

      if (recipeUsers.isNotEmpty) {
        throw UserAlreadyFoundCrudException();
      }

      if (id == 0) {
        throw CouldNotCreateUserCrudException();
      }
      return RecipeUser(email: email, id: id);
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<void> deleteUser({required String email}) async {
    try {
      final database = await databaseService.database;

      final recipeUsers = await database.query(
        userTable,
        limit: 1,
        where: "$emailCoulmn = ?",
        whereArgs: [email.toLowerCase()],
      );

      if (recipeUsers.isEmpty) {
        UserNotFoundCrudException();
      }

      final deletedCount = await database.delete(
        userTable,
        where: "$emailCoulmn = ?",
        whereArgs: [email.toLowerCase()],
      );

      if (deletedCount != 0) {
        throw CouldNotDeleteUserCrudException();
      }
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<RecipeUser> getUser({required String email}) async {
    try {
      final database = await databaseService.database;

      final recipeUsers = await database.query(
        userTable,
        limit: 1,
        where: "$emailCoulmn = ?",
        whereArgs: [email.toLowerCase()],
      );

      if (recipeUsers.isEmpty) {
        throw UserNotFoundCrudException();
      }

      return RecipeUser.fromRowMap(recipeUsers.first);
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }
}
