import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwiseReportNew.dart';

class ItemProductModel extends ItemProduct {

  const ItemProductModel({
    required super.productCode,
    required super.productName,
    required super.qty,
    required super.subTotal,
    required super.taxAmount,
    required super.totalAmount,
    required super.purchaseCost,
    required super.categoryName,
  });

  factory ItemProductModel.fromJson(Map<String, dynamic> json) {

    return ItemProductModel(
      productCode: json["ProductCode"] ?? "",
      productName: json["ProductName"] ?? "",
      qty: json["Qty"] ?? 0,
      subTotal: json["SubTotal"] ?? "0",
      taxAmount: json["TaxAmount"] ?? "0",
      totalAmount: json["TotalAmount"] ?? "0",
      purchaseCost: json["PurchaseCost"] ?? "0",
      categoryName: json["category_name"] ?? "",
    );
  }
}