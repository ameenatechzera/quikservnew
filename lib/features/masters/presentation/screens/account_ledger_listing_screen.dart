import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/account_ledger_creation_screen.dart';
import 'package:quikservnew/features/masters/presentation/widgets/accountledger_widgets.dart';

class AccountLedgerListingScreen extends StatelessWidget {
  const AccountLedgerListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ledgers = [
      "Cash",
      "Purchase Account",
      "Sales Account",
      "Salary",
      "Rent",
      "Transportation",
      "Wages",
      "Loading and Unloading",
      "Tax on Sales",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FA),
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          "Account Ledgers",
          style: TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: const AccountLedgerCreationScreen(),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: ledgers.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return AccountLedgerTile(title: ledgers[index]);
        },
      ),
    );
  }
}
