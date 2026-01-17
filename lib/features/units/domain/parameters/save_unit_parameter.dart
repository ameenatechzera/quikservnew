class SaveUnitRequestModel {
  final String unitName;
  final int branchId;
  final int createdUser;

  SaveUnitRequestModel({
    required this.unitName,
    required this.branchId,
    required this.createdUser,
  });

  factory SaveUnitRequestModel.fromJson(Map<String, dynamic> json) {
    return SaveUnitRequestModel(
      unitName: json['unit_name'],
      branchId: json['branchId'],
      createdUser: json['createdUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit_name': unitName,
      'branchId': branchId,
      'createdUser': createdUser,
    };
  }
}
