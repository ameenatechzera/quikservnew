import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/category/domain/parameters/edit_category_parameter.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';

class CategoryCreationWidget extends StatelessWidget {
  const CategoryCreationWidget({
    super.key,
    required this.categoryController,
    required this.isLoading,
    required this.isEdit,
    required this.categoryId,
  });

  final TextEditingController categoryController;
  final bool isLoading;
  final bool isEdit;
  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: const Icon(Icons.image, size: 60, color: Colors.black26),
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
                    if (isEdit) {
                      context.read<CategoriesCubit>().editCategory(
                        categoryId!,
                        EditCategoryRequestModel(
                          categoryName: categoryName,
                          categoryImage: '',
                          branchId: 1,
                          modifiedUser: 1,
                        ),
                      );
                    } else {
                      context.read<CategoriesCubit>().saveCategory(
                        SaveCategoryRequestModel(
                          categoryName: categoryName,
                          categoryImage: "",
                          branchId: 1,
                          createdUser: 1,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.save),
            label: Text(
              isEdit ? "Update" : "Add",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
