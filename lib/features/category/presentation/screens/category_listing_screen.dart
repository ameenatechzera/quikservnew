import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/category/presentation/screens/category_creation_screen.dart';

class CategoriesListingScreen extends StatelessWidget {
  const CategoriesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Load categories from LOCAL DB only (once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().fetchCategories();
    });
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: "Categories",

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

      body: BlocConsumer<CategoriesCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryDeleteSuccess) {
            showAnimatedToast(
              context,
              message: "Category deleted successfully",
              isSuccess: true,
            );
          }

          if (state is CategoryDeleteError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is CategoryDeleteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryLoading) {
            // Show loader while fetching
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            final categories = state.categories;

            if (categories.categories!.isEmpty) {
              return const Center(child: Text("No categories found"));
            }
            return ListView.separated(
              itemCount: categories.categories!.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
              itemBuilder: (context, index) {
                final category = categories.categories![index];

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // 🔹 Category Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            category.categoryImage != null &&
                                category.categoryImage!.isNotEmpty
                            ? Image.memory(
                                decodeImage(category.categoryImage!)!,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 52,
                                  height: 52,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                      ),

                      const SizedBox(width: 12),

                      // 🔹 Category Name
                      Expanded(
                        child: Text(
                          category.categoryName ?? 'Unnamed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // 🔹 Edit Icon
                      IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.edit, color: Colors.black54),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryCreationScreen(
                                categoryId: category.categoryId,
                                initialCategoryName: category.categoryName,
                              ),
                            ),
                          );
                        },
                      ),

                      // 🔹 Delete Icon
                      IconButton(
                        iconSize: 18,
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmDialog(
                            context: context,
                            categoryId: category.categoryId!,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Uint8List? decodeImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  void _showDeleteConfirmDialog({
    required BuildContext context,
    required int categoryId,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text("Are you sure you want to delete this category?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);

                // 🔥 Trigger delete using Cubit
                context.read<CategoriesCubit>().deleteCategory(categoryId);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
