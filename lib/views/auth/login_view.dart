import 'package:flutter/material.dart';
import 'package:my_recipe_box/exceptions/auth/auth_exceptions.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
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
      appBar: AppBar(title: loginTextWidget, backgroundColor: appBarColor),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: emailHint),
          ),
          TextField(
            controller: _passwordController,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(hintText: passwordHint),
          ),
          TextButton(
            onPressed: () async {
              try {
                final authService = AuthService.fireAuth();

                final currentUser = await authService.login(
                  _emailController.text,
                  _passwordController.text,
                );
                if(context.mounted && currentUser.isEmailVerified){
                  Navigator.of(context).pushReplacementNamed(
                    recipeViewRoute,
                    );
                }
                else{
                  if(context.mounted){
                    Navigator.of(context).pushReplacementNamed(
                    emailVerificationRoute,
                    );
                  }
                }
              } on AuthException catch (authError) {
                if (authError is InvalidEmailAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: invalidEmailErrorMessage,
                    );
                  }
                } else if (authError is UserNotFoundAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: userNotFoundErrorMessage,
                    );
                  }
                }
                else if (authError is WrongPasswordAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: wrongPasswordErrorMessage,
                    );
                  }
                }
                else if (authError is NetworkErrorAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: networkErrorMessage,
                    );
                  }
                } else {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: unknownErrorMessage,
                    );
                  }
                }
              } catch (authError) {
                if (context.mounted) {
                  await showErrorDialog(
                    context: context,
                    errorMessage: unknownErrorMessage,
                  );
                }
              }
            },
            child: loginTextWidget,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(registerViewRoute);
            },
            child: toRegisterTextWidget,
          ),
        ],
      ),
    );
  }
}
