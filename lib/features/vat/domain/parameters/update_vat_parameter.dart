class EditVatRequestModel {
  final String vatName;
  final int vatPercentage;
  final int branchId;
  final int modifiedUser;

  EditVatRequestModel({
    required this.vatName,
    required this.vatPercentage,
    required this.branchId,
    required this.modifiedUser,
  });

  Map<String, dynamic> toJson() {
    return {
      "vatName": vatName,
      "vatPercentage": vatPercentage,
      "branchId": branchId,
      "modified_user": modifiedUser,
    };
  }
}
