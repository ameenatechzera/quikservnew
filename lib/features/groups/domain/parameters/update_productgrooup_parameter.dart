class EditProductGroupRequestModel {
  final String groupName;
  final int branchId;
  final int modifiedUser;

  EditProductGroupRequestModel({
    required this.groupName,
    required this.branchId,
    required this.modifiedUser,
  });

  Map<String, dynamic> toJson() => {
    "group_name": groupName,
    "branchId": branchId,
    "modified_user": modifiedUser,
  };
}
