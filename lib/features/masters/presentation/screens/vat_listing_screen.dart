import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/vat_creation_screen.dart';

class VatsListingScreen extends StatelessWidget {
  VatsListingScreen({super.key});

  // 🔹 Static list (later replace with API / Cubit state)
  final List<String> units = ['gst-18%'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColors.theme,
        elevation: 0,

        title: const Text(
          'Units',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: VatCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: units.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _unitRow(
            unitName: units[index],
            onEdit: () {
              // TODO: Edit Unit
            },
            onDelete: () {
              // TODO: Delete Unit
            },
          );
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
