import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';

class ProductGroupCreationScreen extends StatefulWidget {
  final int? groupId;
  final String? initialName;

  const ProductGroupCreationScreen({super.key, this.groupId, this.initialName});

  @override
  State<ProductGroupCreationScreen> createState() =>
      _ProductGroupCreationScreenState();
}

class _ProductGroupCreationScreenState
    extends State<ProductGroupCreationScreen> {
  late final TextEditingController unitController;

  bool get isEdit => widget.groupId != null;

  @override
  void initState() {
    super.initState();
    unitController = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: isEdit ? "Edit Product Group" : "Add Product Group",
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 TextField
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: "Product Group",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 26),

            /// 🔹 Add / Edit Button
            BlocConsumer<GroupsCubit, GroupsState>(
              listener: (context, state) {
                if (state is GroupAdded || state is GroupEdited) {
                  showAnimatedToast(
                    context,
                    message: isEdit
                        ? "Product Group updated successfully"
                        : "Product Group added successfully",
                    isSuccess: true,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       isEdit
                  //           ? "Product Group updated successfully"
                  //           : "Product Group added successfully",
                  //     ),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // );
                  Navigator.pop(context);
                }

                if (state is GroupAddError) {
                  showAnimatedToast(
                    context,
                    message: state.error,
                    isSuccess: false,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(state.error),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                }

                if (state is GroupEditError) {
                  showAnimatedToast(
                    context,
                    message: state.error,
                    isSuccess: false,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(state.error),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                }
              },
              builder: (context, state) {
                final isLoading =
                    state is GroupAddLoading || state is GroupEditLoading;

                return SizedBox(
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
