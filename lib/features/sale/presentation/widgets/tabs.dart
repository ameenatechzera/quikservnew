import 'package:flutter/material.dart';

Widget buildTab(
  BuildContext context,
  String title,
  bool selected,
  VoidCallback onTap,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    ),
  );
}
