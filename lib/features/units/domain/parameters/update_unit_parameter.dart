class EditUnitRequestModel {
  final String unitName;
  final int branchId;
  final int modifiedUser;

  EditUnitRequestModel({
    required this.unitName,
    required this.branchId,
    required this.modifiedUser,
  });

  Map<String, dynamic> toJson() {
    return {
      "unit_name": unitName,
      "branchId": branchId,
      "modified_user": modifiedUser,
    };
  }

  factory EditUnitRequestModel.fromJson(Map<String, dynamic> json) {
    return EditUnitRequestModel(
      unitName: json['unit_name'] ?? '',
      branchId: json['branchId'] ?? 0,
      modifiedUser: json['modified_user'] ?? 0,
    );
  }
}
