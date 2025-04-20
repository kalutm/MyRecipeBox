import 'package:flutter/material.dart';
import 'package:my_recipe_box/exceptions/auth_exceptions.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/auth/auth_user.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
import 'package:my_recipe_box/utils/constants/hint_texts.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:my_recipe_box/widgets/text_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: registerTextWidget,
        backgroundColor: appBarColor,
      ),
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
                final AuthUser user = await AuthService.fireAuth().register(_emailController.text, _passwordController.text);
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    emailVerificationRoute,
                    (route) => false,
                  );
                }
              } on AuthException catch (authError) {
                if (authError is WeakPasswordAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: weakPasswordErrorMessage
                      );
                  }
                } else if (authError is EmailAlreadyInUseAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: emailAlreadyInUSeErrorMessage
                      );
                  }
                } else if (authError is InvalidEmailAuthException) {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: invalidEmailErrorMessage
                      );
                  }
                } else {
                  if (context.mounted) {
                    await showErrorDialog(
                      context: context,
                      errorMessage: unknownErrorMessage
                      );
                  }
                }
              } catch (authError) {
                if (context.mounted) {
                  await showErrorDialog(
                    context: context,
                    errorMessage: unknownErrorMessage
                    );
                }
              }
            },
            child: registerTextWidget,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(loginViewRoute);
            },
            child: Text("Already have an account? click here to login."),
          ),
        ],
      ),
    );
  }
}