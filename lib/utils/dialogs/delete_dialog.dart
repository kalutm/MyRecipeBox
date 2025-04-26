import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showGenericDialog<bool>(
    context: context,
    dialogBuilder: () => {"delete": true, "cancel": false},
    title: title,
    content: content,
  ).then((response) {
    if (response != null) {
      return response;
    }
    return false;
  });
}
