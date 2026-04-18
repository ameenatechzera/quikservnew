import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/category/presentation/widgets/category_creation_widget.dart';

class CategoryCreationScreen extends StatelessWidget {
  final int? categoryId;
  final String? initialCategoryName;
  CategoryCreationScreen({
    super.key,
    this.categoryId,
    this.initialCategoryName,
  });

  final TextEditingController categoryController = TextEditingController();
  bool get isEdit => categoryId != null;
  @override
  Widget build(BuildContext context) {
    if (isEdit && categoryController.text.isEmpty) {
      categoryController.text = initialCategoryName ?? '';
    }
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(title: isEdit ? "Edit Category" : "Add Category"),

      body: BlocConsumer<CategoriesCubit, CategoryState>(
        listener: (context, state) {
          // ✅ SUCCESS
          if (state is CategoryAddSuccess) {
            showAnimatedToast(
              context,
              message: "Category added successfully",
              isSuccess: true,
            );
            Navigator.pop(context, true);
          }
          if (state is CategoryEditSuccess) {
            showAnimatedToast(
              context,
              message: "Category updated successfully",
              isSuccess: true,
            );
            Navigator.pop(context, true);
          }
          // ❌ ERROR
          if (state is CategoryAddError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
          if (state is CategoryEditError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          final bool isLoading =
              state is CategoryAddLoading || state is CategoryEditLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: CategoryCreationWidget(
              categoryController: categoryController,
              isLoading: isLoading,
              isEdit: isEdit,
              categoryId: categoryId,
            ),
          );
        },
      ),
    );
  }
}
