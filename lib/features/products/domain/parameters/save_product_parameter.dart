class ProductSaveRequest {
  final String productName;
  final String productNameFL;
  final int baseUnitId;
  final int groupId;
  final int categoryId;
  final int vatId;
  final double purchaseRate;
  final bool isActive;
  final int branchId;
  final int descriptionStatus;
  final int createdUser;
  final List<ConversionDetail> conversionDetails;

  ProductSaveRequest({
    required this.productName,
    required this.productNameFL,
    required this.baseUnitId,
    required this.groupId,
    required this.categoryId,
    required this.vatId,
    required this.purchaseRate,
    required this.isActive,
    required this.branchId,
    required this.descriptionStatus,
    required this.createdUser,
    required this.conversionDetails,
  });

  factory ProductSaveRequest.fromJson(Map<String, dynamic> json) {
    return ProductSaveRequest(
      productName: json['ProductName'],
      productNameFL: json['ProductNameFL'],
      baseUnitId: json['BaseUnitId'],
      groupId: json['GroupId'],
      categoryId: json['CategoryId'],
      vatId: json['VatId'],
      purchaseRate: (json['PurchaseRate'] as num).toDouble(),
      isActive: json['isActive'],
      branchId: json['branchId'],
      descriptionStatus: json['descriptionStatus'],
      createdUser: json['CreatedUser'],
      conversionDetails: (json['conversionDetails'] as List)
          .map((e) => ConversionDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ProductName": productName,
      "ProductNameFL": productNameFL,
      "BaseUnitId": baseUnitId,
      "GroupId": groupId,
      "CategoryId": categoryId,
      "VatId": vatId,
      "PurchaseRate": purchaseRate,
      "isActive": isActive,
      "branchId": branchId,
      "descriptionStatus": descriptionStatus,
      "CreatedUser": createdUser,
      "conversionDetails": conversionDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class ConversionDetail {
  final int unitId;
  final String barcode;
  final double conversionRate;
  final double mrp;
  final double salesPrice;
  final int branchId;

  ConversionDetail({
    required this.unitId,
    required this.barcode,
    required this.conversionRate,
    required this.mrp,
    required this.salesPrice,
    required this.branchId,
  });

  factory ConversionDetail.fromJson(Map<String, dynamic> json) {
    return ConversionDetail(
      unitId: json['UnitId'],
      barcode: json['barcode'],
      conversionRate: (json['conversionRate'] as num).toDouble(),
      mrp: (json['MRP'] as num).toDouble(),
      salesPrice: (json['SalesPrice'] as num).toDouble(),
      branchId: json['branchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "UnitId": unitId,
      "barcode": barcode,
      "conversionRate": conversionRate,
      "MRP": mrp,
      "SalesPrice": salesPrice,
      "branchId": branchId,
    };
  }
}
