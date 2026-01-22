class EditCategoryRequestModel {
  final String categoryName;
  final String categoryImage;
  final int branchId;
  final int modifiedUser;

  EditCategoryRequestModel({
    required this.categoryName,
    required this.categoryImage,
    required this.branchId,
    required this.modifiedUser,
  });

  /// 🔹 Convert model → JSON
  Map<String, dynamic> toJson() {
    return {
      "category_name": categoryName,
      "CategoryImage": categoryImage,
      "branchId": branchId,
      "ModifiedUser": modifiedUser,
    };
  }
}
