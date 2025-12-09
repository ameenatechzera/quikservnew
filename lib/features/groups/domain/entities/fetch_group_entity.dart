class FetchGroupResponse {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchGroupDetails>? groupDetails;

  FetchGroupResponse({
    this.status,
    this.error,
    this.message,
    this.groupDetails,
  });
}

class FetchGroupDetails {
  final int? groupId;
  final String? groupName;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final int? branchId;

  FetchGroupDetails({
    this.groupId,
    this.groupName,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.branchId,
  });
}
