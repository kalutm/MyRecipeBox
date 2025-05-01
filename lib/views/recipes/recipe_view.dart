import 'package:flutter/material.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/services/crud/recipe_user_service.dart';
import 'package:my_recipe_box/utils/constants/databas_constants.dart';
import 'package:my_recipe_box/utils/constants/enums/recipe_layout_enum.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/delete_dialog.dart';
import 'package:my_recipe_box/utils/dialogs/logout_dialog.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_list.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';



class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  int _selectedIndex = 0;
  bool isFavoriteList = false;
  RecipeLayout _currentLayout = RecipeLayout.grid; // Default to grid view

  late Future<void> _recipeUserFuture;

  late Stream<List<Recipe>> _favoriteRecipeStream;
  late Stream<List<Recipe>> _recipeStream;

  late RecipeService _recipeService;
  late RecipeUserService _recipeUserService;

  Future<void> _createOrGetUser() async {
    await _recipeUserService.createOrGetUser(
      email: currentUser.email!,
      setUser: (recipeUser) async {
        await _recipeService.setCurrentUser(recipeUser);
      },
    );
  }

  Future<void> seedAllRecipes() async {
    for (final r in demoRecipes) {
      await _recipeService.insertSeedRecipe(recipe: r);
    }
  }

  @override
  void initState() {
    _recipeService = RecipeService();
    _recipeUserService = RecipeUserService();
    _favoriteRecipeStream = _recipeService.favoriteRecipeStream;
    _recipeStream = _recipeService.recipeStream;

    _recipeUserFuture = _createOrGetUser();
    super.initState();
  }

  AuthUser get currentUser => AuthService.fireAuth().currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isFavoriteList = (index == 1); // Update isFavoriteList based on tab
    });
  }

  void _setLayout(RecipeLayout layout) {
    setState(() {
      _currentLayout = layout;
    });
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _recipeUserFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error!.toString()));
            }
            return StreamBuilder<List<Recipe>>(
              stream: isFavoriteList ? _favoriteRecipeStream : _recipeStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error!.toString()));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                              "Are you sure that you want to delete the recipe: ${recipe.title}",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Implement Side Drawer
          },
        ),
        title: const Text('MyRecipeBox'),
        actions: [
          TextButton(onPressed: () async {
            await seedAllRecipes();
          }, child: seedTextWidget),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement Search Functionality
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'logout':
                  final response = await showLogoutDialog(context: context);
                  if (response) {
                    await AuthService.fireAuth().logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        loginViewRoute,
                        (route) => false,
                      );
                    }
                  }
                  break;
                case 'list':
                  _setLayout(RecipeLayout.list);
                  break;
                case 'grid':
                  _setLayout(RecipeLayout.grid);
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'list',
                    child: Text('List View'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'grid',
                    child: Text('Grid View'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                  // Add Dark Mode toggle and QR-Share import here in the future
                ],
          ),
        ],
      ),
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
            icon: Icon(Icons.shopping_cart),
            label: 'Meal planner',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
