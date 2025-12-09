import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';

class FetchCategoryResponseModel extends FetchCategoryResponseEntity {
  FetchCategoryResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchCategoryDetailsModel>? super.categories,
  });

  factory FetchCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchCategoryResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      categories:
          json['categories'] != null
              ? List<FetchCategoryDetailsModel>.from(
                json['categories'].map(
                  (x) => FetchCategoryDetailsModel.fromJson(x),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "error": error,
      "message": message,
      "categories":
          categories
              ?.map((x) => (x as FetchCategoryDetailsModel).toJson())
              .toList(),
    };
  }
}

class FetchCategoryDetailsModel extends FetchCategoryDetailsEntity {
  FetchCategoryDetailsModel({
    super.categoryId,
    super.categoryName,
    super.categoryImage,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
  });

  factory FetchCategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchCategoryDetailsModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryImage: json['categoryimage'],
      branchId: json['branchid'],
      createdDate: json['createddate'],
      createdUser: json['createduser'],
      modifiedDate: json['modifieddate'],
      modifiedUser: json['modifieduser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "category_name": categoryName,
      "categoryimage": categoryImage,
      "branchid": branchId,
      "createddate": createdDate,
      "createduser": createdUser,
      "modifieddate": modifiedDate,
      "modifieduser": modifiedUser,
    };
  }
}
