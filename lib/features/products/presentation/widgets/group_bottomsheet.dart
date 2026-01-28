import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';

Future<void> showGroupBottomSheet({
  required BuildContext context,
  required TextEditingController groupController,
  required void Function(int id, String name) onSelected,
  bool includeAllGroup = false,
}) async {
  // ✅ Trigger API fetch (same as category)
  context.read<GroupsCubit>().fetchGroups();

  final selectedGroup = await showModalBottomSheet<String>(
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
                    "Select Group",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),

                // Groups List
                Expanded(
                  child: BlocBuilder<GroupsCubit, GroupsState>(
                    builder: (context, state) {
                      if (state is GroupsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GroupsLoaded) {
                        final groups =
                            state.groups.groupDetails ??
                            []; // 🔹 Build display list
                        List<GroupItem> displayGroups = [];

                        if (includeAllGroup) {
                          displayGroups.add(
                            GroupItem(
                              id: 0,
                              name: "All Groups",
                              isAllGroup: true,
                            ),
                          );
                        }

                        displayGroups.addAll(
                          groups.map(
                            (grp) => GroupItem(
                              id: grp.groupId!,
                              name: grp.groupName ?? 'Unnamed',
                              isAllGroup: false,
                            ),
                          ),
                        );

                        if (displayGroups.isEmpty) {
                          return const Center(child: Text("No groups found"));
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: displayGroups.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final group = displayGroups[index];
                            final isSelected =
                                groupController.text == group.name;

                            return ListTile(
                              title: Text(group.name),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                groupController.text = group.name;
                                onSelected(group.id, group.name);
                                Navigator.pop(ctx, group.name);
                              },
                            );
                          },
                        );
                      } else if (state is GroupsError) {
                        return Center(child: Text("Error: ${state.error}"));
                      } else {
                        return const SizedBox();
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

  // Update the controller in the calling screen
  if (selectedGroup != null) {
    groupController.text = selectedGroup;
  }
}

class GroupItem {
  final int id;
  final String name;
  final bool isAllGroup;

  GroupItem({required this.id, required this.name, required this.isAllGroup});
}
