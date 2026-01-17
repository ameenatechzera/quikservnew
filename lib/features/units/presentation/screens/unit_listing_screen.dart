import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/units/presentation/screens/unit_creation_screen.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';

class UnitsListingScreen extends StatelessWidget {
  const UnitsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: "Units",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: UnitCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: BlocConsumer<UnitCubit, UnitState>(
        listener: (context, state) {
          if (state is UnitDeleted) {
            showAnimatedToast(
              context,
              message: 'Unit Deleted Successfully',
              isSuccess: true,
            );
            // 🔄 Refresh list
            context.read<UnitCubit>().fetchUnits();
          }

          if (state is UnitDeleteError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is UnitLoading || state is UnitDeleteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnitError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is UnitLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.units.details!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final unit = state.units.details![index];
                return _unitRow(
                  unitName: unit.unitName!,
                  onEdit: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: UnitCreationScreen(
                        unitId: unit.unitId,
                        unitName: unit.unitName,
                      ),
                    );
                  },
                  onDelete: () {
                    _showDeleteConfirmDialog(
                      context: context,
                      unitId: unit.unitId!,
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
  /* ================= DELETE CONFIRM ================= */

  void _showDeleteConfirmDialog({
    required BuildContext context,
    required int unitId,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Unit'),
        content: const Text('Are you sure you want to delete this unit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              context.read<UnitCubit>().deleteUnit(unitId);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
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

          // Edit icon
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, color: Colors.black54, size: 16),
          ),
          const SizedBox(width: 10), // tiny spacing between icons
          // Delete icon
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete, color: Colors.red, size: 16),
          ),
        ],
      ),
    );
  }
}
