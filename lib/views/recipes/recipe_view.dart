import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/services/crud/meal_planner_service.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/services/crud/recipe_user_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:my_recipe_box/utils/constants/enums/recipe_layout_enum.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/delete_dialog.dart';
import 'package:my_recipe_box/views/meal_planner.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_list.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  int _selectedIndex = 0;
  bool isFavoriteList = false;
  bool isInMealPlanner = false;
  RecipeLayout _currentLayout = RecipeLayout.grid; // Default to grid view

  late Future<void> _recipeUserFuture;

  late Stream<List<Recipe>> _favoriteRecipeStream;
  late Stream<List<Recipe>> _recipeStream;
  Stream<List<Recipe>>? _recipeSearchByTitleStream;

  late RecipeService _recipeService;
  late RecipeUserService _recipeUserService;
  late MealPlannerService _mealPlannerService;

  late TextEditingController _searchController;
  bool _isSearching = false;

  Future<void> _createOrGetUser() async {
    await _recipeUserService.createOrGetUser(
      email: currentUser.email!,
      setUser: (recipeUser) async {
        await _recipeService.setCurrentUser(recipeUser);
        await _mealPlannerService.setCurrentUser(recipeUser);
      },
    );
  }

  Future<void> _loadRecipeLayout() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLayout =
        prefs.getString('defaultView') == "grid"
            ? RecipeLayout.grid
            : RecipeLayout.list;
  }

  void _onDefaultViewChanged(String view) {
    _setLayout(view == 'grid' ? RecipeLayout.grid : RecipeLayout.list);
  }

  Future<void> seedAllRecipes() async {
    for (final r in demoRecipes) {
      await _recipeService.insertSeedRecipe(recipe: r);
    }
  }

  @override
  void initState() {
    _loadRecipeLayout();
    _recipeService = RecipeService();
    _recipeUserService = RecipeUserService();
    _mealPlannerService = MealPlannerService();

    _searchController = TextEditingController();

    _favoriteRecipeStream = _recipeService.favoriteRecipeStream;
    _recipeStream = _recipeService.recipeStream;

    _recipeUserFuture = _createOrGetUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  AuthUser get currentUser => AuthService.fireAuth().currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isFavoriteList = (index == 1); // Update isFavoriteList based on tab
      isInMealPlanner = (index == 2); // Update isInMealPlanner based on tab
      _isSearching = false; // Close search when tab changes
      _searchController.clear();
      _recipeSearchByTitleStream = null;
    });
  }

  void _onSearchItemChange() {
    final changedQueryString = _searchController.text;
    _recipeService.onQueryStringChange(changedQueryString);
  }

  void _startSearch() {
    setState(() {
      _recipeSearchByTitleStream = _recipeService.recipeSearchByTitleStream;
      _searchController.addListener(_onSearchItemChange);
      _isSearching = true;
    });
  }

  void _stopSearch() {
    _isSearching = false;
    _recipeSearchByTitleStream = null;
    _searchController.removeListener(_onSearchItemChange);
    _searchController.clear();
  }

  void _setLayout(RecipeLayout layout) {
    setState(() {
      _currentLayout = layout;
    });
  }

  Widget _buildBody() {
    return _isSearching ? _buildSearchBar() : _buildRecipeBody();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _searchController.clear,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: _recipeSearchByTitleStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No recipes found.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      );
                    } else {
                      final recipes = snapshot.data!;
                      return RecipeList(
                        recipes: recipes,
                        isGridView: _currentLayout == RecipeLayout.grid,
                        onDeleteRecipe: (recipe) async {
                          final response = await showDeleteDialog(
                            context: context,
                            title: "Delete",
                            content:
                                "Are you sure that you want to delete the recipe: ${recipe.title}and meal plans associated with it will be deleted.",
                          );
                          if (response) await _recipeService.deleteRecipe(id: recipe.id);
                        },
                        onUpdateRecipe:
                            (recipe) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        CreateUpdateRecipeView(recipe: recipe),
                              ),
                            ),
                        onUpdateFavorite: (recipe) async {
                          await _recipeService.updataRecipeCoulmn(
                            id: recipe.id,
                            coulmn: isFavoritecoulmn,
                            newValue: recipe.isFavorite ? 0 : 1,
                          );
                        },
                      );
                    }
                  case ConnectionState.waiting:
                    return Center(
                      child: Text(
                        'Start typing to search.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  default:
                    return spinkitRotatingCircle;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeBody() {
    return FutureBuilder(
      future: _recipeUserFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error!.toString()));
            }
            return isInMealPlanner
                ? MealPlanner()
                : StreamBuilder<List<Recipe>>(
                  stream:
                      isFavoriteList ? _favoriteRecipeStream : _recipeStream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error!.toString()),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              isFavoriteList
                                  ? 'No favorites yet. Tap ♥ on a recipe to add.'
                                  : 'No recipes yet. Tap "+" to add one.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          );
                        }
                        final recipes = snapshot.data!;

                        return RecipeList(
                          recipes: recipes,
                          isGridView:
                              _currentLayout ==
                              RecipeLayout.grid, // Pass the layout state
                          onDeleteRecipe: (recipe) async {
                            final response = await showDeleteDialog(
                              context: context,
                              title: "Delete",
                              content:
                                  "Are you sure that you want to delete the recipe: ${recipe.title}. Note that all mealplan's associated with this recipe will be deleted",
                            );
                            if (response) await _recipeService.deleteRecipe(id: recipe.id);
                          },
                          onUpdateRecipe:
                              (recipe) => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => CreateUpdateRecipeView(
                                        recipe: recipe,
                                      ),
                                ),
                              ),
                          onUpdateFavorite: (recipe) async {
                            await _recipeService.updataRecipeCoulmn(
                              id: recipe.id,
                              coulmn: isFavoritecoulmn,
                              newValue: recipe.isFavorite ? 0 : 1,
                            );
                          },
                        );
                      default:
                        return const Center(child: spinkitRotatingCircle);
                    }
                  },
                );
          default:
            return const Center(child: spinkitRotatingCircle);
        }
      },
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Text(
              'Welcome!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // navigate if needed
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(settingsViewRoute, arguments: _onDefaultViewChanged);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).pushNamed(aboutViewRoute);
              // Navigate to favorites page
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? null : const Text('Meal Organizer'),
        automaticallyImplyLeading: !_isSearching,
        actions: [
          // for testing purpose
          /*TextButton(onPressed: () async {
            await seedAllRecipes();
          }, child: seedTextWidget),*/
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _stopSearch();
                } else {
                  _startSearch();
                }
              });
            },
          ),
        ],
      ),
      drawer: _drawer(),
      body: _buildBody(),
      floatingActionButton:
          _selectedIndex <
                  2 // Show FAB on Recipes and Favorites
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateUpdateRecipeView(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Recipes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Meal planner',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
