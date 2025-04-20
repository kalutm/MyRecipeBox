import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/models/recipe_user.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev_tool show log;

class RecipeService{

  Database? _database;

  Database _getDatabase(){
    final database = _database;
    if(database != null){
      if(database.isOpen){
        return database;
      }
      throw DatabaseIsnotOpen();
    }
    throw DatabaseDoesNotExist();
  }

  Future<void> open() async{
    if(_database != null){
      throw DatabaseAlreadyOpened();
    }
    try{
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocDir.path, dbName);

      final database = await openDatabase(dbPath);
      _database = database;

      database.execute(userTable);

      database.execute(recipeTable);

    } on MissingPlatformDirectoryException{
        throw UnableToProvideDocumentsDirectory();
    } catch(crudError){
      dev_tool.log(crudError.toString());
      throw CrudException();
    }
  }

  Future<void> close() async{
    final database = _database;
    if(database != null){
      if(!database.isOpen){
        await database.close();
        _database = null;
      }
      throw DatabaseAlreadyClosed();
    }
    throw DatabaseDoesNotExist();
  }

  Future<RecipeUser> createUser({
    required String email,
  }) async {
    try{
      final database = _getDatabase();
    
    final recipeUsers = await database.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
    );

      final id = await database.insert(userTable, {"email": email});

    if(recipeUsers.isNotEmpty){
      throw UserAlreadyFoundCrudException();
    }

    if(id == 0){
      throw CouldNotCreateUserCrudException();
    }
    return RecipeUser(
      email: email,
      id: id.toString(),
      );
    } catch(_){
      rethrow;
    }
    
  }

  Future<void> deleteUser({
    required String email,
  }) async {
    try{
      final database = _getDatabase();
    
    final recipeUsers = await database.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
    );

    if(recipeUsers.isEmpty){
      UserNotFoundCrudException();
    }

    final deletedCount = await database.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
      );

      if(deletedCount != 0){
        throw CouldNotDeleteUserCrudException();
      }
    } catch(_){
      rethrow;
    }
    
  }

  Future<RecipeUser> getUser({
    required String email,
  }) async {
    try{
      final database = _getDatabase();

    final recipeUsers = await database.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
    );

    if(recipeUsers.isEmpty){
      throw UserNotFoundCrudException();
    }

    return RecipeUser.fromRowMap(recipeUsers.first);
  } catch(_){
    rethrow;
  }
}


    

}