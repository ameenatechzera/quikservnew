import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/groups/presentation/screens/product_group_creation_screen.dart';

class ProductCreationWidget extends StatelessWidget {
  const ProductCreationWidget({
    super.key,
    required this.isLoading,
    required this.unitController,
    required this.isEdit,
    required this.widget,
  });

  final bool isLoading;
  final TextEditingController unitController;
  final bool isEdit;
  final ProductGroupCreationScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: isLoading
            ? null
            : () {
                final name = unitController.text.trim();
                if (name.isEmpty) {
                  showAnimatedToast(
                    context,
                    message: "Please enter a group name",
                    isSuccess: false,
                  );
                  return;
                }

                if (isEdit) {
                  /// 🔹 EDIT
                  context.read<GroupsCubit>().editProductGroup(
                    widget.groupId!,
                    EditProductGroupRequestModel(
                      groupName: name,
                      branchId: 1,
                      modifiedUser: 1,
                    ),
                  );
                } else {
                  /// 🔹 ADD
                  context.read<GroupsCubit>().addProductGroup(
                    AddProductGroupRequestModel(
                      productGroupName: name,
                      branchId: 1,
                      createdUser: 1,
                    ),
                  );
                }
              },
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          isEdit ? "Update" : "Add",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
