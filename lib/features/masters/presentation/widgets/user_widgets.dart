import 'package:flutter/material.dart';
import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';

Widget usertextField({
  required String label,
  required TextEditingController controller,
  bool isPassword = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: validator,
  );
}


Widget userDropdownField(
    List<UserTypes> userTypes,
    String? selectedValue,
    ValueChanged<String?> onChanged,
    ) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    decoration: const InputDecoration(
      labelText: "Select user type",
      border: UnderlineInputBorder(),
    ),
    items: userTypes.map((type) {
      return DropdownMenuItem<String>(
        value: type.typeId.toString(),            // stored value
        child: Text(type.userType),    // visible text
      );
    }).toList(),
    onChanged: onChanged,
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

        ],
      ),
    ),
  );
}
