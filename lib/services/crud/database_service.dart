import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipe_box/exceptions/crud/crud_exceptions.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev_tool show log;

class DatabaseService {
  static Database? _database;

  static final singletonInstance = DatabaseService._instance();

  factory DatabaseService() => singletonInstance;

  DatabaseService._instance();

  String? appDocDirPath;

  Future<String> get dbPath async {
    final appDocDir = await getApplicationDocumentsDirectory();
    appDocDirPath = appDocDir.path;
    return join(appDocDir.path, dbName);
  }

  Future<String> saveToDbAndGetRecipeImagePath({required XFile image}) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    final savedImage = File('${appDocDir.path}/$fileName');

    await File(image.path).copy(savedImage.path);

    return savedImage.path;
  }

  Future<Database> _initDb() async {
    final path = await dbPath;
    return await openDatabase(path, version: 1, onCreate: _onCreate, onOpen: _onOpen);
  }

  Future<Database> get database async {
    final db = _database;

    if (db == null) {
      try {
        final database = await _initDb();
        return _database = database;
      } on MissingPlatformDirectoryException {
        throw UnableToProvideDocumentsDirectory();
      } catch (crudError) {
        dev_tool.log(crudError.toString());
        throw CrudException();
      }
    }
    return db;
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute(createUserTable);
    await database.execute(createRecipeTable);
    await database.execute(createMealPlanTable);
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    final database = _database;
    if (database == null) {
      throw DatabaseDoesNotExist();
    }
    if (!database.isOpen) {
      throw DatabaseAlreadyClosed();
    }
    await database.close();
    _database = null;
  }

  Future<void> deleteDb() async {
    await deleteDatabase(await dbPath);
    _database = null;
  }
}
