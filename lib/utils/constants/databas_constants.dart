// data base constants
const dbName = "recipes.db";

// recipe related

const allowedCoulmns = [
  titleCoulmn,
  ingredientsCoulmn,
  stepsCoulmn,
  categoryCoulmn,
  photoPathCoulmn,
  isFavoritecoulmn,
];

// recipe table constants
const userTable = "user";
const recipeTable = "recipe";


const recipeIdCoulmn = "id";
const userIdCoulmn = "user_id";
const titleCoulmn = "title";
const ingredientsCoulmn = "ingredients";
const stepsCoulmn = "steps";
const categoryCoulmn = "category";
const photoPathCoulmn = "photo_path";
const isFavoritecoulmn = "is_favorite";

const createRecipeTable = """ 
CREATE TABLE "recipe" (
	"id"	INTEGER NOT NULL UNIQUE,
	"title"	TEXT NOT NULL,
	"ingredients"	TEXT NOT NULL,
	"steps"	TEXT NOT NULL,
	"category"	TEXT,
	"photo_path"	TEXT,
	"is_favorite"	INTEGER NOT NULL DEFAULT 0,
	"user_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "recipe"("id")
);
""";

// user table constants

const idCoulmn = "id";
const emailCoulmn = "email";

const createUserTable = """
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL UNIQUE,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
""";
