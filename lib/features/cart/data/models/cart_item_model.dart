// class CartItem {
//   final String? productId;
//   final String productName;
//   final double price;
//   int quantity;

//   CartItem({
//     required this.productId,
//     required this.productName,
//     required this.price,
//     this.quantity = 1,
//   });

//   double get totalPrice => price * quantity;
// }
class CartItem {
  final int lineNo;
  final int customerId;
  final String productCode;
  final String productName;
  double qty;
  int oldQty;
  final double salesRate;
  final String unitId;
  final String purchaseCost;
  final int groupId;
  final int categoryId;
  final String productImage;
  final String excludeRate;
  String subtotal;
  final String vatId;
  final String vatAmount;
  String totalAmount;
  String conversion_rate;
  String category;
  String groupName;
  String? product_description;

  CartItem({
    required this.lineNo,
    required this.customerId,
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.oldQty,
    required this.salesRate,
    required this.unitId,
    required this.purchaseCost,
    required this.groupId,
    required this.categoryId,
    required this.productImage,
    required this.excludeRate,
    required this.subtotal,
    required this.vatId,
    required this.vatAmount,
    required this.totalAmount,
    required this.conversion_rate,
    required this.category,
    required this.groupName,
    required this.product_description,
  });

  /// ✅ SAFE total price
  double get totalPrice {
    final rate = salesRate;
    final quantity = qty;
    return rate * quantity;
  }
}
