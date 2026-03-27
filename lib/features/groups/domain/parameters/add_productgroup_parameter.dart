class AddProductGroupRequestModel {
  final String productGroupName;
  final int branchId;
  final int createdUser;

  AddProductGroupRequestModel({
    required this.productGroupName,
    required this.branchId,
    required this.createdUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_name': productGroupName,
      'branchId': branchId,
      'createdUser': createdUser,
    };
  }
}
