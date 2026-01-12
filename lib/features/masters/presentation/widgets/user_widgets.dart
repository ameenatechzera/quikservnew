import 'package:flutter/material.dart';

Widget usertextField({required String label, bool isPassword = false}) {
  return TextField(
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      border: const UnderlineInputBorder(),
    ),
  );
}

Widget userdropdownField() {
  return DropdownButtonFormField<String>(
    decoration: const InputDecoration(
      labelText: "Select usertype",
      border: UnderlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: "supplier", child: Text("Supplier")),
      DropdownMenuItem(value: "cashier", child: Text("Cashier")),
    ],
    onChanged: (value) {},
  );
}

Widget sectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    ),
  );
}

Widget userTile({required String name}) {
  return Card(
    elevation: 1.5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          InkWell(
            onTap: () {
              // delete action
            },
            child: const Icon(Icons.delete, color: Colors.red, size: 22),
          ),
        ],
      ),
    ),
  );
}
