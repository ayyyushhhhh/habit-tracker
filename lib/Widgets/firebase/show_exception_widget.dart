import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_table/Widgets/firebase/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message(exception).toString(),
      defaultActionText: 'OK',
    );

String? _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}
