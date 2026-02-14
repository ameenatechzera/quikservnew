import 'package:flutter/material.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/cart/presentation/screens/cart_screen.dart';

/// 🔑 Controls cart bottom bar visibility
final ValueNotifier<bool> showCartBar = ValueNotifier(false);
Widget cartBottomBar(BuildContext context) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaleFactor: 1.0, // 🔑 LOCK font scaling
    ),
    child: ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartManager().cartItems,
      builder: (context, items, _) {
        if (items.isEmpty) {
          showCartBar.value = false;
          return const SizedBox();
        }
        // Calculate total items and total price
        // final totalItems = items.fold<int>(0, (sum, item_bloc) => sum + item_bloc.qty);
        final totalItems = items.fold<int>(
          0,
          (sum, item) => sum + item.qty.toInt(),
        );

        final totalPrice = items.fold<double>(
          0,
          (sum, item) => sum + item.totalPrice,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // ITEMS COUNT
              Text(
                "$totalItems Item${totalItems > 1 ? 's' : ''}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(width: 12),

              Container(width: 2, height: 20, color: Colors.white54),

              const SizedBox(width: 12),

              // TOTAL PRICE
              Text(
                totalPrice.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              // VIEW CART TEXT
              TextButton(
                child: const Text(
                  "View Cart",
                  style: TextStyle(
                    color: Color(0xFFEAB307),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CartScreen();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),

              // BAG ICON
              const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFFEAB307),
                size: 22,
              ),
            ],
          ),
        );
      },
    ),
  );
}
