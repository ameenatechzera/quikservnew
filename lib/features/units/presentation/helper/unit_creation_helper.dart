import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';

class UnitCreationHelper {
  void showDeleteConfirmDialog({
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
  Widget unitRow({
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
