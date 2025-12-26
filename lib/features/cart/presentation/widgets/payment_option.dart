// ================== PAYMENT OPTION ==================
import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;

  const PaymentOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? Colors.black : Colors.white;
    final Color border = selected ? Colors.black : Colors.grey.shade300;
    final Color textColor = selected ? Colors.white : Colors.black;

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
          Icon(icon, size: 24, color: selected ? Colors.white : Colors.black87),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
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
