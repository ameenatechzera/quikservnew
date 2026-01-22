import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';

class CategoryCreationScreen extends StatelessWidget {
  final int? categoryId;
  final String? initialCategoryName;
  CategoryCreationScreen({
    super.key,
    this.categoryId,
    this.initialCategoryName,
  });

  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CommonAppBar(title: "Add Category"),

      body: BlocConsumer<CategoriesCubit, CategoryState>(
        listener: (context, state) {
          // ✅ SUCCESS
          if (state is CategoryAddSuccess) {
            showAnimatedToast(
              context,
              message: "Category added successfully",
              isSuccess: true,
            );
          }

          // ❌ ERROR
          if (state is CategoryAddError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          final bool isLoading = state is CategoryAddLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Category Name
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                // 🔹 Image Placeholder
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F2F7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.black26,
                        ),
                      ),

                      // 🔹 Add Image Button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          onPressed: () {},
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Add Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            final categoryName = categoryController.text.trim();

                            if (categoryName.isEmpty) {
                              showAnimatedToast(
                                context,
                                message: "Category name is required",
                                isSuccess: false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Category name is required"),
                                ),
                              );
                              return;
                            }

                            context.read<CategoriesCubit>().saveCategory(
                              SaveCategoryRequestModel(
                                categoryName: categoryName,
                                categoryImage: "",
                                branchId: 1,
                                createdUser: 1,
                              ),
                            );
                          },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
