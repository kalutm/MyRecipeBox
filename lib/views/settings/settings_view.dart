import 'package:flutter/material.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/call_backs.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/logout_dialog.dart';
import 'package:my_recipe_box/utils/extensions/arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  final OnUpdateThemeCallback onThemeChanged;
  const SettingsView({super.key, required this.onThemeChanged});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkMode = false;
  String _defaultRecipeView = 'grid';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _defaultRecipeView = prefs.getString('defaultView') ?? 'grid';
    });
  }

  void _saveTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  Future<void> _saveDefaultView(String view, BuildContext context) async {
    final onDefaultViewChanged = context.getArguments<OnUpdateDefaultViewCallback>()!;
    onDefaultViewChanged(view);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultView', view);
    setState(() {
      _defaultRecipeView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Consistent AppBar color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Theme
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: _saveTheme,
            secondary: Icon(_isDarkMode ? Icons.brightness_2 : Icons.brightness_7),
          ),
          const Divider(),

          // Default Recipe View
          ListTile(
            title: const Text('Default Recipe View'),
            subtitle: Text('Recipes will be shown as ${_defaultRecipeView == 'list' ? 'List' : 'Grid'} by default.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _saveDefaultView('list', context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _defaultRecipeView == 'list' ? Theme.of(context).colorScheme.secondary : null,
                  foregroundColor: _defaultRecipeView == 'list' ? Colors.white : null,
                ),
                child: const Text('List'),
              ),
              ElevatedButton(
                onPressed: () => _saveDefaultView('grid', context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _defaultRecipeView == 'grid' ? Theme.of(context).colorScheme.secondary : null,
                  foregroundColor: _defaultRecipeView == 'grid' ? Colors.white : null,
                ),
                child: const Text('Grid'),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(AuthService.fireAuth().currentUser?.email ?? 'Not logged in'),
            subtitle: const Text('Email Address'),
          ),
          const Divider(),

          // Add other settings options here in the future
          // For example:
          // ListTile(
          //   title: const Text('Notifications'),
          //   trailing: Switch(value: false, onChanged: (bool value) {}),
          // ),
          // const Divider(),

          // Logout (Optional here if you have it in the AppBar)
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
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
            },
          ),
        ],
      ),
    );
  }
}