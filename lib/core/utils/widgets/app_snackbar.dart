import 'package:flutter/material.dart';

/// Show a SnackBar with a given message and optional background color
void showAppSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.red, // default is red for errors
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // hide previous
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
