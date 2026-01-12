import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;
  final double amount;

  const PaymentOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? AppColors.black : AppColors.white;
    final Color border = selected ? AppColors.black : Colors.grey.shade300;
    final Color textColor = selected ? AppColors.white : AppColors.black;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: selected ? AppColors.white : Colors.black87,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          /// 🔹 SHOW AMOUNT ONLY WHEN SELECTED
          if (selected)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                amount.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white70 : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
