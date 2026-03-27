import 'package:flutter/material.dart';

Widget unitRow({
  required String unitName,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            unitName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),

        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.edit, color: Colors.black54),
          onPressed: onEdit,
        ),
        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    ),
  );
}
