import 'package:flutter/foundation.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/sale/presentation/widgets/cart_bottom_bar.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  /// 🔑 Cart items list
  final ValueNotifier<List<CartItem>> cartItems = ValueNotifier<List<CartItem>>(
    [],
  );

  void addToCart(CartItem item) {
    final items = List<CartItem>.from(cartItems.value);

    final index = items.indexWhere((e) => e.productCode == item.productCode);

    if (index != -1) {
      // ✅ UPDATE PRICE EVERY TIME
      items[index] = items[index].copyWith(
        qty: items[index].qty + item.qty,
        salesRate: item.salesRate,
      );
    } else {
      items.add(item);
    }

    cartItems.value = items;
  }

  /// ➖ Remove product
  void removeFromCart(String productId) {
    cartItems.value.removeWhere((e) => e.productCode == productId);
    cartItems.notifyListeners();
  }

  /// 🔽 Decrease quantity
  void decreaseQty(int productId) {
    final index = cartItems.value.indexWhere((e) => e.productCode == productId);

    if (index != -1) {
      if (cartItems.value[index].qty > 1) {
        cartItems.value[index].qty--;
      } else {
        cartItems.value.removeAt(index);
      }
      cartItems.notifyListeners();
    }
  }

  /// 💰 Total items
  // int get totalItems =>
  //     cartItems.value.fold(0, (sum, item) => sum + item.quantity);
  int get totalItems =>
      cartItems.value.fold(0, (sum, item) => sum + item.qty.toInt());

  /// 💰 Total price
  double get totalPrice =>
      cartItems.value.fold(0, (sum, item) => sum + item.totalPrice);

  /// ❌ Clear cart
  void clearCart() {
    cartItems.value.clear();
    cartItems.notifyListeners();
    showCartBar.value = false;
  }

  void incrementQuantity(String productId) {
    final index = cartItems.value.indexWhere(
      (item) => item.productCode == productId,
    );
    if (index != -1) {
      cartItems.value[index].qty++;
      cartItems.notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final index = cartItems.value.indexWhere(
      (item) => item.productCode == productId,
    );
    if (index != -1) {
      if (cartItems.value[index].qty > 1) {
        cartItems.value[index].qty--;
      } else {
        // Remove item completely
        cartItems.value.removeAt(index);
        if (cartItems.value.isEmpty) showCartBar.value = false;
      }
      cartItems.notifyListeners();
    }
  }
}
