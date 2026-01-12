import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/widgets/accountledger_widgets.dart';

class AccountLedgerCreationScreen extends StatelessWidget {
  const AccountLedgerCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FA),
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          "Add Account Ledger",
          style: TextStyle(color: AppColors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textField(label: "Ledger Name"),
              const SizedBox(height: 20),

              textField(label: "Ledger Code"),
              const SizedBox(height: 20),

              dropdownField(),
              const SizedBox(height: 20),

              textField(
                label: "Opening Balance",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add Account Ledger",
                    style: TextStyle(
                      fontSize: 16,

                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
