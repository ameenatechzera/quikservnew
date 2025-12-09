class FetchVatResponse {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchVatDetails>? vatDetails;

  FetchVatResponse({this.status, this.error, this.message, this.vatDetails});
}

class FetchVatDetails {
  final int? vatId;
  final String? vatName;
  final int? vatPercentage;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;

  FetchVatDetails({
    this.vatId,
    this.vatName,
    this.vatPercentage,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
  });
}
