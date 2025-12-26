import 'package:flutter/material.dart';

Widget summaryRow(String label, String value, {bool isBold = false}) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ],
  );
}
