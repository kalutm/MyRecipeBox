import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/meal_plan.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/crud/meal_planner_service.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
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

 @override
  void initState() {
    _selectedDay = _focusedDay;
    _loadMealPlans();
    _recipeService = RecipeService();
    _mealPlannerService = MealPlannerService();
  }

 void _onDaySelected(DateTime selected, DateTime focused){
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  Future<void> _loadMealPlans() async {
    final List<MealPlan> loadedPlans = await _mealPlannerService.getAllUserMealPlans;
    setState(() {
      _mealPlans = loadedPlans;
    });
  }

  Future<void> _saveMealPlan(MealPlan mealPlan) async {
    // Replace this with your actual logic to save the meal plan
    await _mealPlannerService.createMealPlan(mealPlan: mealPlan);
    _loadMealPlans(); // Reload the meal plans after saving
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: DateTime.utc(2010, 7, 7),
      lastDay: DateTime.utc(2040, 7, 7),
      onDaySelected: _onDaySelected,
    );
  }
}
