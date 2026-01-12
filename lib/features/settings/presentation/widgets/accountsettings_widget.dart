import 'package:flutter/material.dart';

/// -------- INPUT FIELD UI --------
class InputField extends StatelessWidget {
  final String label;
  final String value;

  const InputField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
