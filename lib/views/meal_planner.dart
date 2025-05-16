import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/meal_plan.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/crud/meal_planner_service.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/utils/dialogs/delete_dialog.dart';
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
  List<MealPlan> _mealPlans = [];
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

  Future<void> _saveMealPlan(
    MealPlan mealPlan, {
    required bool isUpdate,
  }) async {
    isUpdate
        ? await _mealPlannerService.updateMealPlan(newMealPlan: mealPlan)
        : await _mealPlannerService.createMealPlan(mealPlan: mealPlan);
    _loadMealPlans();
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

  void _showAddMealDialog(BuildContext context, {MealPlan? mealPlan}) {
    if (mealPlan != null) {
      setState(() {
        _selectedMealType = mealPlan.mealType;
        _selectedDay = mealPlan.date;
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                mealPlan == null ? 'Add Meal Plan' : 'Update Meal Plan',
                style: Theme.of(context).textTheme.headlineSmall, // Consistent title
              ),
              content: SingleChildScrollView( // Added SingleChildScrollView
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Meal Type',
                        border: OutlineInputBorder(), // Added border
                      ),
                      value: _selectedMealType,
                      items: <String>['Breakfast', 'Lunch', 'Dinner', 'Dessert']
                          .map(
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
                      validator: (value) => value == null || value.isEmpty ? 'Please select meal type' : null, //Added validator
                    ),
                    const SizedBox(height: 16),
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
                              return const Center(child: Text('No recipes found.'));
                            }
                            return DropdownButtonFormField<Recipe>(
                              decoration: const InputDecoration(
                                labelText: 'Recipe',
                                border: OutlineInputBorder(), // Added border
                              ),
                              value: _selectedRecipeForMeal,
                              items: snapshot.data!.map((Recipe recipe) {
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
                              validator: (value) => value == null ? 'Please select a recipe' : null, //Added Validator
                            );
                          default:
                            return const Center(child: spinkitRotatingCircle);
                        }
                      },
                    ),
                  ],
                ),
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
                  style: TextButton.styleFrom( //Added style
                    foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (_selectedDay != null &&
                        _selectedMealType != null &&
                        _selectedRecipeForMeal != null) {
                      final newMealPlan = MealPlan(
                        id: mealPlan?.id,
                        recipeId: _selectedRecipeForMeal!.id,
                        userId: _selectedRecipeForMeal!.userId,
                        date: _selectedDay!,
                        mealType: _selectedMealType!,
                      );
                      _saveMealPlan(newMealPlan, isUpdate: mealPlan != null);
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedMealType = null;
                        _selectedRecipeForMeal = null;
                      });
                    } else {
                      // Optionally show an error message, I removed the inline error for the dropdowns
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
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
    super.initState();
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
          Card( // Added Card
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
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
                headerStyle: HeaderStyle( //Added Header Style
                  formatButtonTextStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  formatButtonDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                calendarStyle: CalendarStyle( //Added Calendar Style
                  defaultTextStyle:
                      TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  weekendTextStyle:
                      TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
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
      return  Center(
        child: Text('No meals planned for this day.',
            style: Theme.of(context).textTheme.bodyMedium), // Added theme
      );
    }
    return ListView.builder(
      itemCount: mealsForDay.length,
      itemBuilder: (context, index) {
        final meal = mealsForDay[index];
        return FutureBuilder<Recipe?>(
          future: _recipeService.getRecipe(
            id: meal.recipeId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return spinkitRotatingCircle;
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',  style: Theme.of(context).textTheme.bodyMedium),
              );
            }
            final recipe = snapshot.data;
            if (recipe == null) {
              return  Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Meal : ${meal.mealType}',  style: Theme.of(context).textTheme.bodyMedium),
                    subtitle: const Text(
                      'Recipe not found',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final response = await showDeleteDialog(
                          context: context,
                          title: "Delete",
                          content:
                              "Are you sure that you want to delete the meal plan",
                        );
                        if (response) {
                          await _mealPlannerService.deleteMealPlan(id: meal.id!);
                          _loadMealPlans();
                        }
                      },
                    ),
                    onTap: () {
                      _showAddMealDialog(context, mealPlan: meal);
                    },
                  ),
                ),
              ); // Handle case where recipe is null
            }
            return Card( // Added Card
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(recipe.title, style: Theme.of(context).textTheme.bodyMedium), // Added theme
                  leading: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                    child: recipe.photoPath == null
                        ? const Icon(
                            Icons.local_pizza,
                            size: 40.0,
                            color: Colors.grey,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(recipe.photoPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 40.0,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                  ),
                  subtitle: Text(meal.mealType,  style: Theme.of(context).textTheme.bodyMedium), // Added theme
                  trailing: IconButton(
                    onPressed: () async {
                      final response = await showDeleteDialog(
                        context: context,
                        title: "Delete",
                        content:
                            "Are you sure that you want to delete the meal plan",
                      );
                      if (response) {
                        await _mealPlannerService.deleteMealPlan(id: meal.id!);
                        _loadMealPlans();
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    _showAddMealDialog(context, mealPlan: meal);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
