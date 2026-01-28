import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';

Future<void> showUnitBottomSheet({
  required BuildContext context,
  required TextEditingController unitController,
  required void Function(int id, String name) onSelected,
}) async {
  final selectedUnit = await showModalBottomSheet<String>(
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
                    "Select Unit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),

                // Unit List
                Expanded(
                  child: BlocBuilder<UnitCubit, UnitState>(
                    builder: (context, state) {
                      if (state is UnitLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UnitLoaded) {
                        final units = state.units.details ?? [];
                        if (units.isEmpty) {
                          return const Center(child: Text("No units found"));
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: units.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final unit = units[index];
                            final isSelected =
                                unitController.text == unit.unitName;

                            return ListTile(
                              title: Text(unit.unitName ?? 'Unnamed'),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                unitController.text = unit.unitName!;
                                onSelected(unit.unitId!, unit.unitName!);
                                Navigator.pop(ctx, unit.unitName);
                              },
                            );
                          },
                        );
                      } else if (state is UnitError) {
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
                      Icons.drag_handle,
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

  // Update controller in the calling screen
  if (selectedUnit != null) {
    unitController.text = selectedUnit;
  }
}
