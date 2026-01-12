import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class VatCreationScreen extends StatelessWidget {
  VatCreationScreen({super.key});

  final TextEditingController unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          "Add Vat ",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Unit Name TextField (underline style)
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: "Vat Typ",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.2),
                ),
              ),
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: "Vat Percentage",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Add Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // orange
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.save, size: 20),
                label: const Text(
                  "Add",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
