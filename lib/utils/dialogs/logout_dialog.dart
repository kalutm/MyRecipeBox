import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    dialogBuilder: () => {"logout": true, "canel": false},
    title: "Logout",
    content: "Are you sure that you want to logout",
  ).then((value) => value ?? false);
}
