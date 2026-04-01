import 'package:flutter/material.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/units/presentation/widgets/unit_creation_widget.dart';

class UnitCreationScreen extends StatelessWidget {
  final int? unitId;
  final String? unitName;
  UnitCreationScreen({super.key, this.unitId, this.unitName});

  final TextEditingController unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Prefill when edit
    if (unitName != null && unitController.text.isEmpty) {
      unitController.text = unitName!;
    }

    final bool isEdit = unitId != null;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CommonAppBar(title: "Add Unit"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Unit Name TextField (underline style)
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: "Unit Name",
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

            // Orange Add Button
            UnitCreationWidget(
              isEdit: isEdit,
              unitController: unitController,
              unitId: unitId,
            ),
          ],
        ),
      ),
    );
  }
}
