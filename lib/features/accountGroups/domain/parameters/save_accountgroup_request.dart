/// Model for adding a Account Group
class SaveAccountGroupRequest {
  final String AccountGroupCode;
  final String accountGroupName;
  final String groupUnder;
  final String narration;
  final String LedgerNextNo;
  final String branchId;
  final String CreatedUser;


  SaveAccountGroupRequest({
    required this.AccountGroupCode,
    required this.accountGroupName,
    required this.groupUnder,
    required this.narration,
    required this.LedgerNextNo,
    required this.branchId,
    required this.CreatedUser,

  });

  /// Convert model to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'AccountGroupCode': AccountGroupCode, // API expects "group_name"
      'accountGroupName': accountGroupName,
      'groupUnder': groupUnder,
      'narration': narration,
      'LedgerNextNo': LedgerNextNo,
      'branchId': branchId,
      'CreatedUser': CreatedUser

    };
  }
}
