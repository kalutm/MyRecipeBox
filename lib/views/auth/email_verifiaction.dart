import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/exceptions/auth/auth_exceptions.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/constants/colors.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';
import 'dart:developer' as dev_tool show log;

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  void _sendEmailVerification() async {
    AuthService.fireAuth().sendVerificationEmail();
  }

  void _startEmailVerificationCheck() async {
    try{
      final wasVerificationSuccessful = await AuthService.fireAuth().startEmailVerificationCheck();
      if(mounted && wasVerificationSuccessful){
        Navigator.of(context).pushNamedAndRemoveUntil(loginViewRoute, (route) => false);
      }
    }
    on EmailVerificationCheckTimeoutException{
      if(mounted){
        await showErrorDialog(
          context: context,
          errorMessage: verificationTimedOutErrorMessage,
          );
      }
    }
    catch(authError){
      if(mounted){
        await showErrorDialog(
          context: context,
           errorMessage: unknownErrorMessage
           );
      }
     dev_tool.log(authError.toString());
    }
  }

  @override
  void initState() {
    _sendEmailVerification();
    _startEmailVerificationCheck();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: emailVerificatoinTextWidget,
        backgroundColor: appBarColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verificationEmailHaveBeenSentTextWidget,
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(emailVerificationRoute);
              },
            child: sendVerificatoinAgainTextWidget
            )
        ],
      )
    );
  }
}