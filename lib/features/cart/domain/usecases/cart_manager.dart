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

  /// ➕ Add product to cart
  void addToCart(CartItem item) {
    final index = cartItems.value.indexWhere((e) => e.qty == item.productCode);

    if (index != -1) {
      cartItems.value[index].qty++;
    } else {
      cartItems.value.add(item);
    }

    cartItems.notifyListeners();
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
