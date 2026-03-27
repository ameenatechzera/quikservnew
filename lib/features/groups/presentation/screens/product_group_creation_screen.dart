import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/groups/presentation/widgets/product_creation_widget.dart';

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
                  Navigator.pop(context);
                }
                if (state is GroupAddError) {
                  showAnimatedToast(
                    context,
                    message: state.error,
                    isSuccess: false,
                  );
                }
                if (state is GroupEditError) {
                  showAnimatedToast(
                    context,
                    message: state.error,
                    isSuccess: false,
                  );
                }
              },
              builder: (context, state) {
                final isLoading =
                    state is GroupAddLoading || state is GroupEditLoading;

                return ProductCreationWidget(
                  isLoading: isLoading,
                  unitController: unitController,
                  isEdit: isEdit,
                  widget: widget,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
