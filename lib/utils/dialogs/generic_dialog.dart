import 'package:flutter/material.dart';

typedef DialogBuilder<T> = Map<String, T> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required DialogBuilder<T> dialogBuilder,
  required String title,
  required String content,
}){
  final actionsMap = dialogBuilder();
  return showDialog<T?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actionsMap.keys.map(
          (action) => TextButton(
            onPressed: () {
              final T? value = actionsMap[action];
              if(value != null){
                return Navigator.of(context).pop(value);
              }
              Navigator.of(context).pop();
            },
            child: Text(action),
            ),
        ).toList()
      );
    },
  );
}