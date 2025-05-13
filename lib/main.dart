import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/views/auth/auth_wrapper.dart';
import 'package:my_recipe_box/views/auth/email_verifiaction.dart';
import 'package:my_recipe_box/views/auth/login_view.dart';
import 'package:my_recipe_box/views/auth/register_view.dart';
import 'package:my_recipe_box/views/drawer/about_view.dart';
import 'package:my_recipe_box/views/recipes/create_update_recipe_view.dart';
import 'package:my_recipe_box/views/recipes/recipe_view.dart';
import 'package:my_recipe_box/views/drawer/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false; // Load initial theme
  runApp(MyRecipeBox(initialDarkMode: isDarkMode));
}

class MyRecipeBox extends StatefulWidget {
  final bool initialDarkMode;
  const MyRecipeBox({super.key, required this.initialDarkMode});

  @override
  State<MyRecipeBox> createState() => _MyRecipeBoxState();
}

class _MyRecipeBoxState extends State<MyRecipeBox> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  // Function to toggle the theme and save the preference
  void _setTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('darkMode', isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: authWrapperRoute,
      routes: {
        authWrapperRoute: (context) => const AuthWrapper(),
        loginViewRoute: (context) => const LoginView(),
        registerViewRoute: (context) => const RegisterView(),
        emailVerificationRoute: (context) => const EmailVerificationView(),
        recipeViewRoute: (context) => RecipeView(), // Pass the callback
        createUpdateRecipeViewRoute: (context) => const CreateUpdateRecipeView(),
        aboutViewRoute: (context) => const AboutView(),
        settingsViewRoute: (context) => SettingsView(onThemeChanged: _setTheme),// Pass the callback
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        primaryColor: Colors.deepOrange,
        hintColor: Colors.grey[600],
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[700],
          ),
          bodyMedium: const TextStyle(fontSize: 16.0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        primaryColor: Colors.deepOrange[800],
        hintColor: Colors.grey[400],
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[400],
          ),
          bodyMedium: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange[800],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange[800],
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepOrange[400],
          unselectedItemColor: Colors.grey[400],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[800],
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          labelStyle: TextStyle(color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}