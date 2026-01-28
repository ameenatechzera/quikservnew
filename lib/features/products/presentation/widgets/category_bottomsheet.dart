import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';

Future<void> showCategoryBottomSheet({
  required BuildContext context,
  required TextEditingController categoryController,
  required void Function(int id, String name) onSelected,
  bool includeAllCategory = false, // Add this parameter
}) async {
  // Trigger API fetch
  context.read<CategoriesCubit>().fetchCategories();
  final selectedCategory = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Select Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),

                // Category List
                Expanded(
                  child: BlocBuilder<CategoriesCubit, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryLoaded) {
                        final categories = state.categories.categories;
                        // Create a list that may include "All Categories"
                        List<CategoryItem> displayCategories = [];

                        if (includeAllCategory) {
                          // Add "All Categories" as the first item
                          displayCategories.add(
                            CategoryItem(
                              id: 0, // Use 0 or -1 for "All"
                              name: "All Categories",
                              isAllCategory: true,
                            ),
                          );
                        }

                        // Add actual categories
                        displayCategories.addAll(
                          categories!.map(
                            (cat) => CategoryItem(
                              id: cat.categoryId!,
                              name: cat.categoryName ?? 'Unnamed',
                              isAllCategory: false,
                            ),
                          ),
                        );

                        if (displayCategories.isEmpty) {
                          return const Center(
                            child: Text("No categories found"),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: displayCategories.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final category = displayCategories[index];
                            final isSelected =
                                categoryController.text == category.name;

                            return ListTile(
                              title: Text(category.name),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                categoryController.text = category.name;
                                // Special handling for "All Categories"
                                if (category.isAllCategory) {
                                  // You can pass -1, 0, or null as ID for "All"
                                  onSelected(category.id, category.name);
                                } else {
                                  onSelected(category.id, category.name);
                                }

                                Navigator.pop(ctx, category.name);
                              },
                            );
                          },
                        );
                      } else if (state is CategoryError) {
                        return Center(child: Text("Error: ${state.error}"));
                      } else {
                        return Container(child: Text('ffffffffff'));
                      }
                    },
                  ),
                ),

                // Bottom drag hint
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (selectedCategory != null) {
    categoryController.text = selectedCategory;
  }
}

// Helper class to handle both real categories and "All Categories"
class CategoryItem {
  final int id;
  final String name;
  final bool isAllCategory;

  CategoryItem({
    required this.id,
    required this.name,
    required this.isAllCategory,
  });
}
