import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/presentation/widgets/accountsettings_widget.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE38A),
        elevation: 0,

        title: const Text(
          "Account Settings",
          style: TextStyle(color: AppColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputField(label: "Cash Ledger *", value: "Cash"),
            const SizedBox(height: 16),

            InputField(label: "Card Ledger *", value: "Cash"),
            const SizedBox(height: 16),

            InputField(label: "Bank Ledger *", value: "Cash"),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,

                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
