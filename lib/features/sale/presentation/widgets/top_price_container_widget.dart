import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class TopPriceContainer extends StatelessWidget {
  final String? price;
  const TopPriceContainer({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: 5,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          price ?? '',
          style: TextStyle(color: AppColors.white, fontSize: 10),
        ),
      ),
    );
  }
}
