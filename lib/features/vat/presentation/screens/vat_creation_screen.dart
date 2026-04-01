import 'package:flutter/material.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/vat/presentation/widgets/vat_add_button.dart';

class VatCreationScreen extends StatelessWidget {
  final int? vatId;
  final String? vatName;
  final int? vatPercentage;
  VatCreationScreen({super.key, this.vatId, this.vatName, this.vatPercentage});

  final TextEditingController vatNameController = TextEditingController();
  final TextEditingController vatPercentageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Prefill when edit
    if (vatName != null && vatNameController.text.isEmpty) {
      vatNameController.text = vatName!;
    }
    if (vatPercentage != null && vatPercentageController.text.isEmpty) {
      vatPercentageController.text = vatPercentage.toString();
    }

    final bool isEdit = vatId != null;
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(title: isEdit ? "Edit TAX" : "Add TAX"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 VAT Name
            TextField(
              controller: vatNameController,
              decoration: const InputDecoration(
                labelText: "TAX Type",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🔹 VAT Percentage
            TextField(
              controller: vatPercentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "TAX Percentage",
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

            // 🔹 Add VAT Button
            VatAddButton(
              isEdit: isEdit,
              vatNameController: vatNameController,
              vatPercentageController: vatPercentageController,
              vatId: vatId,
            ),
          ],
        ),
      ),
    );
  }
}
