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
  CartItem copyWith({double? salesRate, double? qty}) {
    return CartItem(
      lineNo: lineNo,
      customerId: customerId,
      productCode: productCode,
      productName: productName,
      qty: qty ?? this.qty,
      oldQty: oldQty,
      salesRate: salesRate ?? this.salesRate,
      unitId: unitId,
      purchaseCost: purchaseCost,
      groupId: groupId,
      categoryId: categoryId,
      productImage: productImage,
      excludeRate: excludeRate,
      subtotal: subtotal,
      vatId: vatId,
      vatAmount: vatAmount,
      totalAmount: totalAmount,
      conversion_rate: conversion_rate,
      category: category,
      groupName: groupName,
      product_description: product_description,
    );
  }

  double get totalPrice {
    final rate = salesRate;
    final quantity = qty;
    return rate * quantity;
  }
}
