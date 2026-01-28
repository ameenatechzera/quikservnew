// ---------- INPUT FIELDS ----------

import 'package:flutter/material.dart';

Widget textField({
  required String label,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      border: const UnderlineInputBorder(),
    ),
  );
}

Widget dropdownField() {
  return DropdownButtonFormField<String>(
    decoration: const InputDecoration(
      labelText: "Select an Account Group",
      border: UnderlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: "assets", child: Text("Assets")),
      DropdownMenuItem(value: "income", child: Text("Income")),
      DropdownMenuItem(value: "expense", child: Text("Expense")),
      DropdownMenuItem(value: "liability", child: Text("Liability")),
    ],
    onChanged: (value) {},
  );
}

/// ---------- LEDGER LIST TILE ----------
class AccountLedgerTile extends StatelessWidget {
  final String title;

  const AccountLedgerTile({super.key, required this.title});

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
            onPressed: () {
              // TODO: Edit Ledger
            },
          ),

          /// Delete
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () {
              // TODO: Delete Ledger
            },
          ),
        ],
      ),
    );
  }
}
