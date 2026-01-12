import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/account_group_creation_screen.dart';
import 'package:quikservnew/features/masters/presentation/widgets/accountgroup_widgets.dart';

class AccountGroupsListingScreen extends StatelessWidget {
  const AccountGroupsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      "Primary",
      "Expense",
      "Income",
      "Assets",
      "Duties & Taxes",
      "Fixed Assets",
      "Indirect Expenses",
      "Indirect Incomes",
      "Current Liability",
      "Direct Expenses",
      "Direct Incomes",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          "Account Groups",
          style: TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: const AccountGroupCreationScreen(),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          return AccountGroupTile(title: groups[index]);
        },
      ),
    );
  }
}
