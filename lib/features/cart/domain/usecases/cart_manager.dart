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

  /// Add product to cart
  void addToCart(CartItem item) {
    final items = List<CartItem>.from(cartItems.value);

    final index = items.indexWhere((e) => e.productCode == item.productCode);

    if (index != -1) {
      items[index] = items[index].copyWith(
        qty: items[index].qty + item.qty,
        salesRate: item.salesRate,
      );
    } else {
      items.add(item);
    }

    cartItems.value = items;
  }

  ///  Remove product
  void removeFromCart(String productCode) {
    final items = List<CartItem>.from(cartItems.value);
    items.removeWhere((e) => e.productCode == productCode);
    cartItems.value = items;

    if (items.isEmpty) showCartBar.value = false;
  }

  ///  Decrease quantity
  void decreaseQty(String productCode) {
    final items = List<CartItem>.from(cartItems.value);
    final index = items.indexWhere((e) => e.productCode == productCode);

    if (index != -1) {
      if (items[index].qty > 1) {
        items[index] = items[index].copyWith(qty: items[index].qty - 1);
      } else {
        items.removeAt(index);
      }
    }

    cartItems.value = items;

    if (items.isEmpty) showCartBar.value = false;
  }

  ///  Increase quantity
  void incrementQuantity(String productCode) {
    final items = List<CartItem>.from(cartItems.value);

    final index = items.indexWhere((item) => item.productCode == productCode);

    if (index != -1) {
      items[index] = items[index].copyWith(qty: items[index].qty + 1);
    }

    cartItems.value = items;
  }

  ///  Decrement quantity
  void decrementQuantity(String productCode) {
    final items = List<CartItem>.from(cartItems.value);

    final index = items.indexWhere((item) => item.productCode == productCode);

    if (index != -1) {
      if (items[index].qty > 1) {
        items[index] = items[index].copyWith(qty: items[index].qty - 1);
      } else {
        items.removeAt(index);
      }
    }

    cartItems.value = items;

    if (items.isEmpty) showCartBar.value = false;
  }

  ///  Total items
  int get totalItems =>
      cartItems.value.fold(0, (sum, item) => sum + item.qty.toInt());

  ///  Total price
  double get totalPrice =>
      cartItems.value.fold(0, (sum, item) => sum + item.totalPrice);

  ///  Clear cart
  void clearCart() {
    cartItems.value = [];
    showCartBar.value = false;
  }

  ///  Update item price
  void updateItemPrice(String productCode, double newPrice) {
    final items = List<CartItem>.from(cartItems.value);

    final index = items.indexWhere((item) => item.productCode == productCode);

    if (index != -1) {
      items[index] = items[index].copyWith(salesRate: newPrice);
    }

    cartItems.value = items;
  }
}
