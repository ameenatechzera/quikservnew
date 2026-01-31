// ---------- INPUT FIELDS ----------

import 'package:flutter/material.dart';

Widget textField({
  required String label,
  TextInputType keyboardType = TextInputType.text,
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      border: const UnderlineInputBorder(),
    ),
  );
}

/// ---------- LEDGER LIST TILE ----------
class AccountLedgerTile extends StatelessWidget {
  final String title;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  const AccountLedgerTile({
    super.key,
    required this.title,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),

          /// Edit
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
            onPressed: onEdit,
          ),

          /// Delete
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () {
              debugPrint("🟠 Delete icon pressed inside tile");

              if (onDelete != null) {
                onDelete!();
              } else {
                debugPrint("❌ onDelete is NULL");
              }
            },
          ),
        ],
      ),
    );
  }
}
