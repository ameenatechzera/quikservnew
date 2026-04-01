import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';

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
} // 🔹 Show confirmation dialog before deleting

void showDeleteDialog(BuildContext context, int vatId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Tax'),
      content: const Text('Are you sure you want to delete this VAT?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<VatCubit>().deleteVat(vatId);
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
