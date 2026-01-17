class SaveCategoryRequestModel {
  final String categoryName;
  final String categoryImage;
  final int branchId;
  final int createdUser;

  SaveCategoryRequestModel({
    required this.categoryName,
    required this.categoryImage,
    required this.branchId,
    required this.createdUser,
  });

  Map<String, dynamic> toJson() {
    return {
      "category_name": categoryName,
      "CategoryImage": categoryImage,
      "branchId": branchId,
      "CreatedUser": createdUser,
    };
  }
}
