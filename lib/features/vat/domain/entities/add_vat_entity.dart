class AddVatRequestModel {
  final String vatName;
  final int vatPercentage;
  final int branchId;
  final int createdUser;

  AddVatRequestModel({
    required this.vatName,
    required this.vatPercentage,
    required this.branchId,
    required this.createdUser,
  });

  Map<String, dynamic> toJson() {
    return {
      "vatName": vatName,
      "vatPercentage": vatPercentage,
      "branchId": branchId,
      "CreatedUser": createdUser,
    };
  }
}
