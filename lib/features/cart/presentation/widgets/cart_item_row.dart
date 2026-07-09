import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
final Map<String, TextEditingController> qtyControllers = {};
class CartItemRow extends StatelessWidget {
  final CartItem item;
  final int index;

  const CartItemRow({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    TextEditingController getQtyController(CartItem item) {
      return qtyControllers.putIfAbsent(
        item.productCode,
            () => TextEditingController(text: item.qty.toString()),
      );
    }
    return Container(
      color: index.isOdd ? AppColors.white : const Color(0xFFF6F6F6),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$index.', style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.qty} x  ${item.salesRate.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Container(
          //   height: 35,
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   decoration: BoxDecoration(
          //     color: AppColors.white,
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(color: Colors.grey.shade300, width: 1.4),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           final currentQty = (item.qty as num).toDouble();
          //
          //           // ✅ stop at 1 (do not decrement to 0)
          //           if (currentQty <= 1) return;
          //
          //           CartManager().decrementQuantity(item.productCode);
          //         },
          //         child: const Icon(Icons.remove, size: 18),
          //       ),
          //       const SizedBox(width: 10),
          //       Text(
          //         item.qty.toString().padLeft(2, '0'),
          //         style: const TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       GestureDetector(
          //         onTap: () =>
          //             CartManager().incrementQuantity(item.productCode),
          //         child: const Icon(Icons.add, size: 18),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1.4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    final currentQty = (item.qty as num).toDouble();

                    if (currentQty <= 0.01) return;

                    CartManager().decrementQuantity(item.productCode);
                    final updatedItem = CartManager()
                        .cartItems
                        .value
                        .firstWhere((e) => e.productCode == item.productCode);

                    qtyControllers[item.productCode]?.text = updatedItem.qty.toString();
                  },
                  child: const Icon(Icons.remove, size: 18),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 50,
                  height: 35,
                  child: TextField(
                    controller: getQtyController(item),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      final qty = double.tryParse(value);
                      if (qty != null && qty > 0) {
                        CartManager().updateQuantity(item.productCode, qty);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    CartManager().incrementQuantity(item.productCode);

                    final updatedItem = CartManager()
                        .cartItems
                        .value
                        .firstWhere((e) => e.productCode == item.productCode);

                    qtyControllers[item.productCode]?.text = updatedItem.qty.toString();
                  },
                  child: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.totalPrice.toStringAsFixed(2),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => CartManager().removeFromCart(item.productCode),
            child: const Icon(Icons.close, color: AppColors.red, size: 20),
          ),
        ],
      ),
    );
  }
}
