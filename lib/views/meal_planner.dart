import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/meal_plan.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/crud/meal_planner_service.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlanner extends StatefulWidget {
  const MealPlanner({super.key});

  @override
  State<MealPlanner> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlanner> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<MealPlan> _mealPlans = []; // To hold the planned meals
  Recipe? _selectedRecipeForMeal;
  String? _selectedMealType;

  late RecipeService _recipeService;
  late MealPlannerService _mealPlannerService;
  late Stream<List<Recipe>> _recipeStream;

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  List<MealPlan> _eventLoader(DateTime date) {
    return _getMealPlansForDay(date);
  }

  Future<void> _loadMealPlans() async {
    final List<MealPlan> loadedPlans =
        await _mealPlannerService.getAllUserMealPlans;
    setState(() {
      _mealPlans = loadedPlans;
    });
  }

  Future<void> _saveMealPlan(MealPlan mealPlan) async {
    // Replace this with your actual logic to save the meal plan
    await _mealPlannerService.createMealPlan(mealPlan: mealPlan);
    _loadMealPlans(); // Reload the meal plans after saving
  }

  List<MealPlan> _getMealPlansForDay(DateTime day) {
    return _mealPlans
        .where(
          (plan) =>
              plan.date.year == day.year &&
              plan.date.month == day.month &&
              plan.date.day == day.day,
        )
        .toList();
  }

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Meal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Meal Type'),
                    value: _selectedMealType,
                    items:
                        <String>['Breakfast', 'Lunch', 'Dinner', 'Dessert'].map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMealType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Implement a way to select a recipe here
                  // This could be a DropdownButtonFormField<Recipe> or a button
                  // that navigates to a list of recipes.
                  // For simplicity, let's assume you have a list of all recipes:
                  StreamBuilder<List<Recipe>>(
                    stream: _recipeStream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No recipes found.'));
                          }
                          return DropdownButtonFormField<Recipe>(
                            decoration: const InputDecoration(
                              labelText: 'Recipe',
                            ),
                            value: _selectedRecipeForMeal,
                            items:
                                snapshot.data!.map((Recipe recipe) {
                                  return DropdownMenuItem<Recipe>(
                                    value: recipe,
                                    child: Text(recipe.title),
                                  );
                                }).toList(),
                            onChanged: (Recipe? newValue) {
                              setState(() {
                                _selectedRecipeForMeal = newValue;
                              });
                            },
                          );
                        default:
                          return const Center(child: spinkitRotatingCircle);
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedMealType = null;
                      _selectedRecipeForMeal = null;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (_selectedDay != null &&
                        _selectedMealType != null &&
                        _selectedRecipeForMeal != null) {
                      final newMealPlan = MealPlan(
                        recipeId: _selectedRecipeForMeal!.id,
                        userId: _selectedRecipeForMeal!.userId,
                        date: _selectedDay!,
                        mealType: _selectedMealType!,
                      );
                      _saveMealPlan(newMealPlan);
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedMealType = null;
                        _selectedRecipeForMeal = null;
                      });
                    } else {
                      // Optionally show an error message if not all fields are filled
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState(); // Add this line first
    _recipeService = RecipeService();
    _mealPlannerService = MealPlannerService();
    _recipeStream = _recipeService.recipeStream;
    _selectedDay = _focusedDay;
    _loadMealPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 7, 7),
            lastDay: DateTime.utc(2040, 7, 7),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
            onPageChanged: _onPageChanged,
            eventLoader: _eventLoader,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    left: 6,
                    right: 6,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedDay != null)
            Expanded(child: _buildMealListForDay(_selectedDay!)),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddMealDialog(context),
      ),
    );
  }

  Widget _buildMealListForDay(DateTime day) {
    final mealsForDay = _getMealPlansForDay(day);
    if (mealsForDay.isEmpty) {
      return const Center(child: Text('No meals planned for this day.'));
    }
    return ListView.builder(
      itemCount: mealsForDay.length,
      itemBuilder: (context, index) {
        final meal = mealsForDay[index];
        return FutureBuilder<Recipe?>(
          // Use a FutureBuilder
          future: _recipeService.getRecipe(
            id: meal.recipeId,
          ), // Fetch the recipe
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return spinkitRotatingCircle; // Show loading indicator
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              ); // Show error
            }
            final recipe = snapshot.data;
            if (recipe == null) {
              return const Text(
                'Recipe not found',
              ); // Handle case where recipe is null
            }
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.mealType,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(recipe.title), // Display recipe title
                    // Display other recipe details as needed
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
