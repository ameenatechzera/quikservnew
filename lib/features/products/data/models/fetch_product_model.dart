import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

class FetchProductResponseModel extends FetchProductResponse {
  FetchProductResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchProductDetailsModel>? super.productDetails,
  });

  factory FetchProductResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchProductResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      productDetails:
          json['product_details'] != null
              ? List<FetchProductDetailsModel>.from(
                json['product_details'].map(
                  (x) => FetchProductDetailsModel.fromJson(x),
                ),
              )
              : [],
    );
  }
}

class FetchProductDetailsModel extends FetchProductDetails {
  FetchProductDetailsModel({
    super.productCode,
    super.productName,
    super.productNameFL,
    super.baseUnitId,
    super.groupId,
    super.categoryId,
    super.vatId,
    super.purchaseRate,
    super.productImage,
    super.isActive,
    super.branchId,
    super.descriptionStatus,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.barcode,
    super.mrp,
    super.salesPrice,
    super.conversionRate,
    super.unitId,
    super.unitName,
    super.categoryId2,
    super.categoryName,
    super.vatName,
    super.vatPercentage,
    super.productImageByte,
    super.qty,
    super.cartStatus,
    super.cartQty,
    super.vegStatus,
    super.originalPrice,
    required super.group_id,
    required super.groupName,
  });

  factory FetchProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchProductDetailsModel(
      productCode: json['ProductCode'],
      productName: json['ProductName'],
      productNameFL: json['ProductNameFL'],
      baseUnitId: json['BaseUnitId'],
      groupId: json['GroupId'],
      categoryId: json['CategoryId'],
      vatId: json['VatId'],
      purchaseRate: json['PurchaseRate'],
      productImage: json['ProductImage'],
      isActive: json['isActive'],
      branchId: json['branchId'],
      descriptionStatus: json['descriptionStatus'],
      createdDate: json['CreatedDate'],
      createdUser: json['CreatedUser'],
      modifiedDate: json['ModifiedDate'],
      modifiedUser: json['ModifiedUser'],
      barcode: json['barcode'],
      mrp: json['MRP'],
      salesPrice: json['salesPrice'],
      conversionRate: json['conversionRate'],
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      categoryId2: json['category_id'],
      categoryName: json['category_name'],
      vatName: json['vatName'],
      vatPercentage: json['vatPercentage'],
      productImageByte: json['ProductImageByte'],
      qty: json['qty'],
      cartStatus: json['cart_status'],
      cartQty: json['cartQty'],
      vegStatus: json['vegStatus'],
      originalPrice: json['OriginalPrice'],
      group_id: json['group_id'],
      groupName: json['group_name'],
    );
  }
}
