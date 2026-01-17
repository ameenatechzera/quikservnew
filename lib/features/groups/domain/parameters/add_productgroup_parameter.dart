/// Model for adding a Product Group
class AddProductGroupRequestModel {
  final String productGroupName;
  final int branchId;
  final int createdUser;

  AddProductGroupRequestModel({
    required this.productGroupName,
    required this.branchId,
    required this.createdUser,
  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'group_name': productGroupName, // API expects "group_name"
      'branchId': branchId,
      'createdUser': createdUser,
    };
  }
}
