import 'package:flutter/material.dart';

class AppData {
  static String appVersion =
      '2.2'; //extra 1 not passing issue (formtype) fixed 05-02-2026
  static String? saleType;
  // Simple global state manager
  static ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);

}
