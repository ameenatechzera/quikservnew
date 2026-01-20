import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/masters/presentation/screens/user_creation_screen.dart';
import 'package:quikservnew/features/masters/presentation/widgets/user_widgets.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3F6),
      appBar: CommonAppBar(
        title: "Users List",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page:  UserCreationScreen(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle("Suppliers"),
          const SizedBox(height: 8),
          userTile(name: "John"),

          const SizedBox(height: 16),
          sectionTitle("Cashiers"),
          const SizedBox(height: 8),
          userTile(name: "Haris"),
        ],
      ),
    );
  }
}
