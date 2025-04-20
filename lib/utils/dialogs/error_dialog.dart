
import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String errorMessage,
}){
  return showGenericDialog(
    context: context,
    dialogBuilder: () => {
      "ok": null,
    },
    title: "An Error Occured", 
    content: errorMessage
    );
}
// generic
const invalidEmailErrorMessage = "Invalid email! please Use a valid email";
const unknownErrorMessage = "unknown error! some unexpected error has happend please try again later";

// login error messages
const userNotFoundErrorMessage = "User not found! please register before you login";
const wrongPasswordErrorMessage = "Wrong password! please enter the correct password";
const networkErrorMessage = "Network error! please connect to the internet";


// register error messages
const weakPasswordErrorMessage = "Weak password! Your password must atleast be 6 charachters long and must have a letter and a number";
const emailAlreadyInUSeErrorMessage = "Email taken! This email is already in use";

// email verification error messages
const verificationTimedOutErrorMessage = "Verification has timed out please click the resend button";