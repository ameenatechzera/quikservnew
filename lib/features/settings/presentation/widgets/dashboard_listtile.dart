import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';

Widget buildTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Widget page,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {
      AppNavigator.pushSlide(context: context, page: page);
    },
  );
}
