class FetchCategoryResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchCategoryDetailsEntity>? categories;

  FetchCategoryResponseEntity({
    this.status,
    this.error,
    this.message,
    this.categories,
  });
}

class FetchCategoryDetailsEntity {
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;

  FetchCategoryDetailsEntity({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
  });
}
