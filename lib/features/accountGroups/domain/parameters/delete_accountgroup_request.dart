/// Model for adding a Account Group
class DeleteAccountGroupRequest {
  final String accGroupId;



  DeleteAccountGroupRequest({
    required this.accGroupId,

  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'accGroupId': accGroupId, // API expects "group_name"

    };
  }
}
