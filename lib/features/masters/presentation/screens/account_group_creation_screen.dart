import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';

class AccountGroupCreationScreen extends StatelessWidget {
  const AccountGroupCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: const CommonAppBar(title: "Add Group"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GROUP NAME
            const Text(
              "Group",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const TextField(
              decoration: InputDecoration(
                isDense: true,
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// SELECT ACCOUNT GROUP
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select under which Account Group",
                labelStyle: TextStyle(fontSize: 13),
                border: UnderlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: "primary", child: Text("Primary")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
                DropdownMenuItem(value: "income", child: Text("Income")),
              ],
              onChanged: (value) {},
            ),

            const SizedBox(height: 30),

            /// ADD BUTTON
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,

                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
