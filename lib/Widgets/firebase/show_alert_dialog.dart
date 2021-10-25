import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) {
  return showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
          TextButton(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        TextButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
