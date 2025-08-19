import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/models/recipe_user.dart';
import 'package:my_recipe_box/services/crud/database_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev_tool show log;

class RecipeService {
  final databaseService = DatabaseService();
  RecipeUser? _currentUser;

  Stream<List<Recipe>> get recipeStream => _recipeStreamController.stream.map(
    (recipeList) =>
        recipeList.where((recipe) {
          final currentUser = _currentUser;
          if (currentUser == null) throw UserShouldBeSetBeforeReadingRecipes();

          return recipe.userId == currentUser.id;
        }).toList(),
  );

  Stream<List<Recipe>> get recipeSearchByTitleStream => _recipeSearchByTitleStreamController.stream;

  Stream<List<Recipe>> get favoriteRecipeStream => recipeStream.map(
    (userRecipeList) =>
        userRecipeList.where((userRecipe) => userRecipe.isFavorite).toList(),
  );

  late final StreamController<List<Recipe>> _recipeStreamController;
  List<Recipe> _cachedRecipes = [];

  final StreamController<List<Recipe>> _recipeSearchByTitleStreamController = StreamController<List<Recipe>>.broadcast();

  static final _cachedInstance = RecipeService._instance();

  RecipeService._instance() {
    _recipeStreamController = StreamController<List<Recipe>>.broadcast(
      onListen: () => _recipeStreamController.add(_cachedRecipes),
    );
    _recipeSearchByTitleStreamController.add([]);
  }

  Future<void> setCurrentUser(RecipeUser user) async {
    _currentUser = user;
    try {
      await _cacheAllRecipes();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  factory RecipeService() {
    return _cachedInstance;
  }

  Future<void> _cacheAllRecipes() async {
    final allRecipes = await getAllRecipes();
    _cachedRecipes = allRecipes;
    _recipeStreamController.add(_cachedRecipes);
  }

  Future<Recipe> createRecipe({required int userId}) async {
    try {
      final database = await databaseService.database;

      final id = await database.insert(recipeTable, {
        userIdCoulmn: userId,
        titleCoulmn: "",
        ingredientsCoulmn: jsonEncode([]),
        stepsCoulmn: jsonEncode([]),
        isFavoritecoulmn: 0,
      });

      if (id == 0) {
        throw CouldNotCreateRecipeCrudException();
      }
      final newRecipe = await getRecipe(id: id);

      _cachedRecipes.add(newRecipe);
      _recipeStreamController.add(_cachedRecipes);

      return newRecipe;
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<Recipe> insertSeedRecipe({required Recipe recipe}) async {
    try {
      final database = await databaseService.database;

      final id = await database.insert(recipeTable, recipe.toMap());

      if (id == 0) {
        throw CouldNotCreateRecipeCrudException();
      }
      final newRecipe = await getRecipe(id: id);

      _cachedRecipes.add(newRecipe);
      _recipeStreamController.add(_cachedRecipes);

      return newRecipe;
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }

  Future<String> saveAndGetRecipeImage({required XFile image}) async {
    return await databaseService.saveToDbAndGetRecipeImagePath(image: image);
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
      dev_tool.log(recipes.runtimeType.toString());

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
      await databaseService.database;
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

  Future<List<Recipe>> getQueryRecipes(String queryString) async {
    try{
      final currentUser = _currentUser;
      if(currentUser == null){
        throw UserShouldBeSetBeforeReadingRecipes();
      }
      final userId = currentUser.id;
      final database = await databaseService.database;

      final recipes = await database.query(
      recipeTable,
      where: 'LOWER($titleCoulmn) LIKE LOWER(?) AND $userIdCoulmn = ?',
      whereArgs: ['%$queryString%', userId],
    );
    return recipes.map((recipe) => Recipe.fromRowMap(recipe)).toList();

    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }

  }

  void onQueryStringChange(String queryString) async{
    final recipes = await getQueryRecipes(queryString);
    _recipeSearchByTitleStreamController.add(recipes);
  }

  Future<int> updateRecipe({required Recipe newRecipe}) async {
    try {
      await getRecipe(id: newRecipe.id);

      final database = await databaseService.database;
      final updateCount = await database.update(
        recipeTable,
        newRecipe.toMap(),
        where: "$idCoulmn = ?",
        whereArgs: [newRecipe.id],
      );

      if (updateCount == 0) {
        throw CouldNotUpdateRecipeCrudException();
      }

      _cachedRecipes.removeWhere((recipe) => recipe.id == newRecipe.id);
      _cachedRecipes.add(newRecipe);
      _recipeStreamController.add(_cachedRecipes);

      return updateCount;
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

  Future<int> updataRecipeCoulmn({
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
        {coulmn: newValue},
        where: "$idCoulmn = ?",
        whereArgs: [id],
      );

      if (updateCount == 0) {
        throw CouldNotUpdateRecipeCrudException();
      }

      final updatedRecipe = await getRecipe(id: id);
      _cachedRecipes.removeWhere((recipe) => recipe.id == id);
      _cachedRecipes.add(updatedRecipe);
      _recipeStreamController.add(_cachedRecipes);

      return updateCount;
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

      _cachedRecipes.removeWhere((recipe) => recipe.id == id);
      _recipeStreamController.add(_cachedRecipes);
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

      final deletedCount = await database.delete(recipeTable);
      _cachedRecipes = [];
      _recipeStreamController.add(_cachedRecipes);

      return deletedCount;
    } on DatabaseException catch (crudError) {
      dev_tool.log(crudError.toString());
      throw CrudException();
    } catch (crudError) {
      dev_tool.log(crudError.toString());
      rethrow;
    }
  }
}
