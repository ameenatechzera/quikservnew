import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class Loginlocks extends StatelessWidget {
  const Loginlocks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.lock, color: AppColors.black),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.grid_view, color: AppColors.black),
        ),
      ],
    );
  }
}
