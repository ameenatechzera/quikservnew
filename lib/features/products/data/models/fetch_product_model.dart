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
      productDetails: json['product_details'] != null
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

  // factory FetchProductDetailsModel.fromJson(Map<String, dynamic> json) {
  //   return FetchProductDetailsModel(
  //     productCode: json['ProductCode'],
  //     productName: json['ProductName'],
  //     productNameFL: json['ProductNameFL'],
  //     baseUnitId: json['BaseUnitId'],
  //     groupId: json['GroupId'],
  //     categoryId: json['CategoryId'],
  //     vatId: json['VatId'],
  //     purchaseRate: json['PurchaseRate'],
  //     productImage: json['ProductImage'],
  //     isActive: json['isActive'],
  //     branchId: json['branchId'],
  //     descriptionStatus: json['descriptionStatus'],
  //     createdDate: json['CreatedDate'],
  //     createdUser: json['CreatedUser'],
  //     modifiedDate: json['ModifiedDate'],
  //     modifiedUser: json['ModifiedUser'],
  //     barcode: json['barcode'],
  //     mrp: json['MRP'],
  //     salesPrice: json['salesPrice'],
  //     conversionRate: json['conversionRate'],
  //     unitId: json['unit_id'],
  //     unitName: json['unit_name'],
  //     categoryId2: json['category_id'],
  //     categoryName: json['category_name'],
  //     vatName: json['vatName'],
  //     vatPercentage: json['vatPercentage'],
  //     productImageByte: json['ProductImageByte'],
  //     qty: json['qty'],
  //     cartStatus: json['cart_status'],
  //     cartQty: json['cartQty'],
  //     vegStatus: json['vegStatus'],
  //     originalPrice: json['OriginalPrice'],
  //     group_id: json['group_id'],
  //     groupName: json['group_name'],
  //   );
  // }
  factory FetchProductDetailsModel.fromJson(Map<String, dynamic> json) {
    String? s(dynamic v) => v == null ? null : v.toString();

    int? i(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return FetchProductDetailsModel(
      // String? fields -> ALWAYS toString()
      productCode: s(json['ProductCode']),
      productName: s(json['ProductName']),
      productNameFL: s(json['ProductNameFL']),
      purchaseRate: s(json['PurchaseRate']),
      productImage: s(json['ProductImage']),
      createdDate: s(json['CreatedDate']),
      createdUser: s(json['CreatedUser']),
      modifiedDate: s(json['ModifiedDate']),
      modifiedUser: s(json['ModifiedUser']),
      barcode: s(json['barcode']),
      mrp: s(json['MRP']),
      salesPrice: s(json['salesPrice']),
      conversionRate: s(json['conversionRate']),
      unitName: s(json['unit_name']),
      categoryName: s(json['category_name']),
      vatName: s(json['vatName']),
      productImageByte: s(json['ProductImageByte']),
      originalPrice: s(json['OriginalPrice']),

      // int? fields -> safe parse
      baseUnitId: i(json['BaseUnitId']),
      groupId: i(json['GroupId']),
      categoryId: i(json['CategoryId']),
      vatId: i(json['VatId']),
      isActive: i(json['isActive']),
      branchId: i(json['branchId']),
      descriptionStatus: i(json['descriptionStatus']),
      unitId: i(json['unit_id']),
      categoryId2: i(json['category_id']),
      vatPercentage: i(json['vatPercentage']),
      qty: i(json['qty']),
      cartQty: i(json['cartQty']),

      // bool? fields (handle 0/1/true/false)
      cartStatus: json['cart_status'] == null
          ? null
          : (json['cart_status'] is bool
                ? json['cart_status'] as bool
                : json['cart_status'].toString() == '1' ||
                      json['cart_status'].toString().toLowerCase() == 'true'),
      vegStatus: json['vegStatus'] == null
          ? null
          : (json['vegStatus'] is bool
                ? json['vegStatus'] as bool
                : json['vegStatus'].toString() == '1' ||
                      json['vegStatus'].toString().toLowerCase() == 'true'),

      // required fields
      group_id: i(json['group_id']) ?? 0,
      groupName: s(json['group_name']) ?? '',
    );
  }
}
