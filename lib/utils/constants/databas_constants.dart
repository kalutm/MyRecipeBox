import 'package:my_recipe_box/models/recipe.dart';

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

// table names
const userTable = "user";
const recipeTable = "recipe";
const mealPlanTable = "meal_plan";

// recipe table constants
const recipeIdCoulmn = "id";
const userIdCoulmn = "user_id";
const titleCoulmn = "title";
const ingredientsCoulmn = "ingredients";
const stepsCoulmn = "steps";
const categoryCoulmn = "category";
const photoPathCoulmn = "photo_path";
const isFavoritecoulmn = "is_favorite";

const createRecipeTable = """ 
CREATE TABLE IF NOT EXISTS "recipe" (
	"id"	INTEGER NOT NULL UNIQUE,
	"title"	TEXT NOT NULL,
	"ingredients"	TEXT NOT NULL,
	"steps"	TEXT NOT NULL,
	"category"	TEXT,
	"photo_path"	TEXT,
	"is_favorite"	INTEGER NOT NULL DEFAULT 0,
	"user_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
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

// meal planner table constants

const mealIdCoulmn = "id";
const mealUserIdCoulmn = "user_id";
const mealRecipeIdCoulmn = "recipe_id";
const mealDateCoulmn = "date";
const mealTypeCoulmn = "meal_type";

const createMealPlanTable = """ 
CREATE TABLE IF NOT EXISTS "meal_plan" (
	"id"	INTEGER NOT NULL UNIQUE,
	"recipe_id"	INTEGER NOT NULL,
  "user_id"	INTEGER NOT NULL,
	"date"	TEXT NOT NULL,
	"meal_type"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("recipe_id") REFERENCES "recipe"("id"),
  FOREIGN KEY("user_id") REFERENCES "user"("id")
);
""";

final demoRecipes = <Recipe>[
  Recipe(
    id: 1,
    userId: 1,
    title: 'Baklava',
    ingredients: [
      '16 oz phyllo dough',
      '1 cup melted butter',
      '2 cups chopped walnuts',
      '1 cup honey',
      '½ cup sugar',
      '1 tsp ground cinnamon',
    ],
    steps: [
      'Preheat oven to 175°C (350°F).',
      'Layer 8 phyllo sheets brushing each with butter.',
      'Sprinkle nut–cinnamon mix; repeat layering.',
      'Top with final 8 buttered sheets and cut into diamonds.',
      'Bake 30 mins until golden.',
      'Boil honey, sugar & a splash of water for syrup; pour over hot baklava.',
    ],
    category: 'Dessert',
    photoPath: null,
  ),

  Recipe(
    id: 2,
    userId: 1,
    title: 'Classic Burger',
    ingredients: [
      '500g ground beef',
      '4 burger buns',
      'Lettuce leaves',
      '4 tomato slices',
      '4 cheese slices',
      '1 onion, sliced',
    ],
    steps: [
      'Form 4 patties; season with salt & pepper.',
      'Grill or pan-fry patties 4 mins/side.',
      'Toast buns lightly.',
      'Assemble: bun, patty, cheese, veggies, top bun.',
    ],
    category: 'Lunch',
    photoPath: null,
  ),

  Recipe(
    id: 3,
    userId: 1,
    title: 'Cheesy Calzone',
    ingredients: [
      '2 cups all-purpose flour',
      '1 tsp instant yeast',
      '¾ cup warm water',
      '1 tbsp olive oil',
      '½ tsp salt',
      '½ cup pizza sauce',
      '1 cup shredded mozzarella',
      '½ cup ricotta cheese',
    ],
    steps: [
      'Mix dough ingredients; knead & let rise 1h.',
      'Preheat oven 220°C (425°F).',
      'Roll dough, spread sauce & cheeses on half.',
      'Fold, seal edges; bake 15–18 mins until golden.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 4,
    userId: 1,
    title: 'Margherita Pizza',
    ingredients: [
      '1 pizza dough ball',
      '½ cup tomato sauce',
      '1 cup mozzarella',
      'Fresh basil leaves',
      'Olive oil drizzle',
    ],
    steps: [
      'Preheat oven to 250°C with pizza stone.',
      'Stretch dough thin; top with sauce & cheese.',
      'Bake 8–10 mins until crust bubbles.',
      'Garnish with basil & oil.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 5,
    userId: 1,
    title: 'Sambusa',
    ingredients: [
      '10 samosa wrappers',
      '250g ground beef',
      '1 small onion, chopped',
      '1 tsp berbere (or curry) spice',
      'Salt & pepper',
    ],
    steps: [
      'Sauté onion & beef with spices until cooked.',
      'Fill wrappers, fold into triangles; seal edges.',
      'Deep-fry until golden & crisp.',
    ],
    category: 'Lunch',
    photoPath: null,
  ),

  Recipe(
    id: 6,
    userId: 1,
    title: 'Spaghetti al Pomodoro',
    ingredients: [
      '200g spaghetti',
      '2 tbsp olive oil',
      '2 garlic cloves, sliced',
      '400g canned tomatoes',
      'Salt & basil to taste',
    ],
    steps: [
      'Cook spaghetti per packet directions.',
      'Sauté garlic in oil until fragrant.',
      'Add tomatoes, simmer 10 mins; season.',
      'Toss pasta in sauce; serve with basil.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 7,
    userId: 1,
    title: 'Injera',
    ingredients: [
      '2 cups teff flour',
      'Water (to batter consistency)',
      'Pinch of salt',
    ],
    steps: [
      'Mix flour & water; cover & ferment 1–2 days.',
      'Stir in salt; heat nonstick skillet.',
      'Pour batter in spiral; cover & cook 2–3 mins.',
      'Remove when holes form and edges lift.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 8,
    userId: 1,
    title: 'Fluffy Pancakes',
    ingredients: [
      '1½ cups flour',
      '1 tbsp sugar',
      '1 tsp baking powder',
      '1 egg',
      '1¼ cups milk',
      '2 tbsp melted butter',
    ],
    steps: [
      'Whisk dry ingredients; add egg, milk & butter.',
      'Heat skillet; pour ¼ cup batter per pancake.',
      'Cook until bubbles form, flip & finish.',
    ],
    category: 'Breakfast',
    photoPath: null,
  ),

  Recipe(
    id: 9,
    userId: 1,
    title: 'Creamy Oatmeal',
    ingredients: [
      '1 cup rolled oats',
      '2 cups milk or water',
      'Pinch of salt',
      'Sweetener & toppings',
    ],
    steps: [
      'Bring liquid & salt to boil.',
      'Stir in oats; simmer 5 mins, stirring.',
      'Serve with fruits, nuts or honey.',
    ],
    category: 'Breakfast',
    photoPath: null,
  ),

  Recipe(
    id: 10,
    userId: 1,
    title: 'Fish and Chips',
    ingredients: [
      '400g white fish fillets',
      '1 cup flour',
      '1 cup beer (or water)',
      '3 potatoes, cut into fries',
      'Oil for frying',
      'Salt',
    ],
    steps: [
      'Make batter: flour + beer; season.',
      'Coat fish, fry till golden; drain.',
      'Fry potatoes until crisp; season.',
      'Serve with lemon & tartar sauce.',
    ],
    category: 'Lunch',
    photoPath: null,
  ),

  Recipe(
    id: 11,
    userId: 1,
    title: 'Doro Wat',
    ingredients: [
      '1 kg chicken pieces',
      '4 onions, finely chopped',
      '3 tbsp berbere spice',
      '3 tbsp niter kibbeh (spiced butter)',
      '4 garlic cloves, minced',
      '2 hard-boiled eggs',
    ],
    steps: [
      'Cook onions until deeply caramelized.',
      'Stir in garlic & berbere; add niter kibbeh.',
      'Add chicken & water; simmer 45 mins.',
      'Add eggs in last 10 mins; serve with injera.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 12,
    userId: 1,
    title: 'Kitfo',
    ingredients: [
      '500g lean beef, minced',
      '2 tbsp niter kibbeh',
      '1 tbsp mitmita spice',
      'Salt to taste',
    ],
    steps: [
      'Warm butter & spices in pan briefly.',
      'Toss in minced beef off-heat; mix well.',
      'Serve warm with injera & cheese.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 13,
    userId: 1,
    title: 'Derek Tibs',
    ingredients: [
      '500g beef cubes',
      '1 onion, sliced',
      '1 green chili, sliced',
      '2 tbsp niter kibbeh',
      'Fresh rosemary or cardamom (optional)',
    ],
    steps: [
      'Heat spiced butter; sauté onion & chili.',
      'Add beef & herbs; stir-fry until browned.',
      'Season with salt & serve hot.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 14,
    userId: 1,
    title: 'Fish Curry',
    ingredients: [
      '500g firm fish chunks',
      '1 onion, chopped',
      '2 tbsp curry powder',
      '1 cup coconut milk',
      '2 garlic cloves, minced',
      '1 tomato, chopped',
    ],
    steps: [
      'Sauté onion & garlic; add curry powder.',
      'Stir in tomato & coconut milk; simmer 5 mins.',
      'Add fish; cook 8–10 mins until done.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),

  Recipe(
    id: 15,
    userId: 1,
    title: 'Misir Wat',
    ingredients: [
      '1 cup red lentils',
      '2 onions, chopped',
      '2 tbsp berbere spice',
      '3 tbsp niter kibbeh',
      '2 garlic cloves, minced',
    ],
    steps: [
      'Cook onions until soft; add garlic & berbere.',
      'Stir in lentils & water; simmer 20 mins.',
      'Finish with spiced butter; serve with injera.',
    ],
    category: 'Dinner',
    photoPath: null,
  ),
];
