import 'package:flutter/material.dart';
import 'package:my_recipe_box/exceptions/auth/auth_exceptions.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/constants/hint_texts.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: loginTextWidget),
      body: Center(
        // Center the content on the screen
        child: SingleChildScrollView(
          // Make it scrollable for smaller screens
          padding: const EdgeInsets.all(
            24.0,
          ), // Add some padding around the content
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center items vertically
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, // Make buttons and text fields take full width
            children: [
              Text(
                'Welcome Back!',
                style:
                    Theme.of(
                      context,
                    ).textTheme.headlineSmall, // Use a themed headline
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText:
                      emailHint, // Use labelText for better Material Design
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: passwordHint, // Use labelText
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                // Use ElevatedButton for the primary action
                onPressed: () async {
                  // ... your login logic ...
                  try {
                    final authService = AuthService.fireAuth();
                    final currentUser = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (context.mounted && currentUser.isEmailVerified) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(recipeViewRoute);
                    } else {
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(emailVerificationRoute);
                      }
                    }
                  } on AuthException catch (authError) {
                    // ... your error handling logic ...
                    String errorMessage = unknownErrorMessage;
                    if (authError is InvalidEmailAuthException) {
                      errorMessage = invalidEmailErrorMessage;
                    } else if (authError is UserNotFoundAuthException) {
                      errorMessage = userNotFoundErrorMessage;
                    } else if (authError is WrongPasswordAuthException) {
                      errorMessage = wrongPasswordErrorMessage;
                    } else if (authError is NetworkErrorAuthException) {
                      errorMessage = networkErrorMessage;
                    }
                    if (context.mounted) {
                      await showErrorDialog(
                        context: context,
                        errorMessage: errorMessage,
                      );
                    }
                  } catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(
                        context: context,
                        errorMessage: unknownErrorMessage,
                      );
                    }
                  }
                },
                child: SizedBox(
                  // Ensure the button has some vertical padding
                  height: 48.0,
                  child: Center(child: loginTextWidget),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    registerViewRoute,
                  ); // Using pushReplacementNamed for auth flow
                },
                child: toRegisterTextWidget,
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  // Placeholder for "Forgot Password?"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Forgot Password? Feature coming soon!'),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
