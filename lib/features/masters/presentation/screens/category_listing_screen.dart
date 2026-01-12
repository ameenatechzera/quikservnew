import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/category_creation_screen.dart';

class CategoriesListingScreen extends StatelessWidget {
  CategoriesListingScreen({super.key});

  // 🔹 Static categories (replace with API later)
  final List<Map<String, String>> categories = [
    {
      "name": "Juices",
      "image":
          "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          "Categories",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: CategoryCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
        itemBuilder: (context, index) {
          final category = categories.first;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                // 🔹 Category Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    category["image"]!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                // 🔹 Category Name
                Expanded(
                  child: Text(
                    category["name"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // 🔹 Edit Icon
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.edit, color: Colors.black54),
                  onPressed: () {},
                ),

                // 🔹 Delete Icon
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
