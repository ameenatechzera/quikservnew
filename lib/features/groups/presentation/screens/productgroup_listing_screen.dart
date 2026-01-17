import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/groups/presentation/screens/product_group_creation_screen.dart';

class ProductgroupListingScreen extends StatelessWidget {
  const ProductgroupListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 Trigger fetchGroups once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupsCubit>().fetchGroups();
    });
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: "Product Groups",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: const ProductGroupCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: BlocConsumer<GroupsCubit, GroupsState>(
        listener: (context, state) {
          if (state is GroupsError ||
              state is GroupAddError ||
              state is GroupDeleteError) {
            final error = state is GroupsError
                ? state.error
                : state is GroupAddError
                ? state.error
                : (state as GroupDeleteError).error;
            showAnimatedToast(context, message: error, isSuccess: false);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(error), backgroundColor: Colors.red),
            // );
          }
          if (state is GroupDeleted) {
            showAnimatedToast(
              context,
              message: 'Group Deleted Successfully',
              isSuccess: true,
            ); // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Group deleted successfully!"),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          }
          if (state is GroupAdded) {
            showAnimatedToast(
              context,
              message: "Group added successfully!",
              isSuccess: false,
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Group added successfully!"),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          }
        },
        builder: (context, state) {
          if (state is GroupsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupsLoaded) {
            if (state.groups.groupDetails!.isEmpty) {
              return const Center(child: Text("No groups found"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.groups.groupDetails!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final group = state.groups.groupDetails![index];

                return _unitRow(
                  unitName: group.groupName!,
                  onEdit: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: ProductGroupCreationScreen(
                        groupId: group.groupId,
                        initialName: group.groupName!,
                      ),
                    );
                  },
                  onDelete: () async {
                    Future.microtask(() async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Group"),
                          content: const Text(
                            "Are you sure you want to delete this group?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm ?? false) {
                        // Trigger delete in cubit
                        context.read<GroupsCubit>().deleteProductGroup(
                          group.groupId!,
                        );
                      }
                    });
                  },
                );
              },
            );
          }
          if (state is GroupsError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // 🔹 Single Unit Row
  Widget _unitRow({
    required String unitName,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        //border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              unitName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.edit, color: Colors.black54),
            onPressed: onEdit,
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
