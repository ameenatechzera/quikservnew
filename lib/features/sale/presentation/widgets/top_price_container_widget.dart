import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class TopPriceContainer extends StatelessWidget {
  final String? price;
  final VoidCallback? onTap;
  const TopPriceContainer({super.key, this.price, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: 5,
      child: InkWell(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          child: Text(
            price ?? '',
            style: TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
