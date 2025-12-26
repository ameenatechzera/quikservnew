import 'package:floor/floor.dart';

class FetchProductResponse {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchProductDetails>? productDetails;

  FetchProductResponse({
    this.status,
    this.error,
    this.message,
    this.productDetails,
  });
}

@Entity(tableName: 'tbl_products', primaryKeys: ['productCode'])
class FetchProductDetails {
  final String? productCode;
  final String? productName;
  final String? productNameFL;
  final int? baseUnitId;
  final int? groupId;
  final int? categoryId;
  final int? vatId;
  final String? purchaseRate;
  final String? productImage;
  final int? isActive;
  final int? branchId;
  final int? descriptionStatus;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final String? barcode;
  final String? mrp;
  final String? salesPrice;
  final String? conversionRate;
  final int? unitId;
  final String? unitName;
  final int group_id; // separate field
  final String groupName;
  final int? categoryId2;
  final String? categoryName;
  final String? vatName;
  final int? vatPercentage;
  final String? productImageByte;
  final int? qty;
  final bool? cartStatus;
  final int? cartQty;
  final bool? vegStatus;
  final String? originalPrice;

  FetchProductDetails({
    this.productCode,
    this.productName,
    this.productNameFL,
    this.baseUnitId,
    this.groupId,
    required this.group_id,
    required this.groupName,
    this.categoryId,
    this.vatId,
    this.purchaseRate,
    this.productImage,
    this.isActive,
    this.branchId,
    this.descriptionStatus,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.barcode,
    this.mrp,
    this.salesPrice,
    this.conversionRate,
    this.unitId,
    this.unitName,
    this.categoryId2,
    this.categoryName,
    this.vatName,
    this.vatPercentage,
    this.productImageByte,
    this.qty,
    this.cartStatus,
    this.cartQty,
    this.vegStatus,
    this.originalPrice,
  });
}
