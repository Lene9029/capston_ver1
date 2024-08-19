import 'dart:io';


import 'package:path_provider/path_provider.dart';
import 'package:recipe_page_new/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  late Database database;
  static final DbHelper dbHelper = DbHelper();
  final String tableName = 'recipes';
  final String nameColumn = 'name';
  final String idColumn = 'id';
  final String isFavoriteColumn = 'isFavorite';
  final String ingredientsColumn = 'ingredients';
  final String instructionsColumn = 'instructions';
  final String preperationTimeColumn = 'preperationTime';
  final String imageColumn = 'image';

  final String allergensName = 'allergenName';
  final String restrictions = 'restrictions';

  Future<void> initDatabase() async {
    database = await connectToDatabase();
    
  }
  
 
 

    
      
  Future<Database> connectToDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/recipes.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $preperationTimeColumn INTEGER, $isFavoriteColumn INTEGER, $ingredientsColumn TEXT, $instructionsColumn TEXT, $imageColumn TEXT, $allergensName TEXT, $restrictions TEXT)');
            
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute(
            'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $preperationTimeColumn INTEGER, $isFavoriteColumn INTEGER, $ingredientsColumn TEXT, $instructionsColumn TEXT, $imageColumn TEXT,  $allergensName TEXT, $restrictions TEXT)');
        
      },
      onDowngrade: (db, oldVersion, newVersion) {
        db.delete(tableName);
        
      },

    );
  }
  
   

  Future<List<RecipeModel>> getAllRecipes() async {
    List<Map<String, dynamic>> tasks = await database.query(tableName);
    return tasks.map((e) => RecipeModel.fromMap(e)).toList();
  }

  

 Future<void> insertNewRecipe(RecipeModel recipeModel) async {
    await database.insert(tableName, recipeModel.toMap());  
  }

  Future<void> deleteRecipe(RecipeModel recipeModel) async {
    await database.delete(tableName, where: '$idColumn=?', whereArgs: [recipeModel.id]);
  }

  Future<void> deleteRecipes() async {
    await database.delete(tableName);
  }

  Future<void> updateRecipe(RecipeModel recipeModel) async {
    await database.update(
        tableName,
        {
          isFavoriteColumn: recipeModel.isFavorite ? 1 : 0,
          nameColumn: recipeModel.name,
          preperationTimeColumn: recipeModel.preperationTime,
          imageColumn: recipeModel.image?.path,
          ingredientsColumn: recipeModel.ingredients,
          instructionsColumn: recipeModel.instructions,
          allergensName: recipeModel.allergensName,
          restrictions: recipeModel.restrictions
        },
        where: '$idColumn=?',
        whereArgs: [recipeModel.id]);
  }
  
  Future<void> updateIsFavorite(RecipeModel recipeModel) async {
    await database.update(
        tableName, 
        {isFavoriteColumn: !recipeModel.isFavorite ? 1 : 0},
        where: '$idColumn=?', 
        whereArgs: [recipeModel.id]);
  }
}
