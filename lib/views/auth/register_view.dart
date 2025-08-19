import 'package:flutter/material.dart';
import 'package:my_recipe_box/exceptions/auth/auth_exceptions.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/constants/hint_texts.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';

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
      appBar: AppBar(title: registerTextWidget),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create an Account',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: emailHint,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: passwordHint,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService.fireAuth().register(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        emailVerificationRoute,
                        (route) => false,
                      );
                    }
                  } on AuthException catch (authError) {
                    String errorMessage = unknownErrorMessage;
                    if (authError is WeakPasswordAuthException) {
                      errorMessage = weakPasswordErrorMessage;
                    } else if (authError is EmailAlreadyInUseAuthException) {
                      errorMessage = emailAlreadyInUSeErrorMessage;
                    } else if (authError is InvalidEmailAuthException) {
                      errorMessage = invalidEmailErrorMessage;
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
                  height: 48.0,
                  child: Center(child: registerTextWidget),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(loginViewRoute);
                },
                child: toLoginTextWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
