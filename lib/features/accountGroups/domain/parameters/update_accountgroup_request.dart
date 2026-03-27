class UpdateAccountGroupRequest {
  final String accountGroupCode;
  final String accountGroupName;
  final String groupUnder;
  final String narration;
  final String ledgerNextNo;
  final String branchId;
  final String modifiedUser;
  final String accGroupId;

  UpdateAccountGroupRequest({
    required this.accountGroupCode,
    required this.accountGroupName,
    required this.groupUnder,
    required this.narration,
    required this.ledgerNextNo,
    required this.branchId,
    required this.modifiedUser,
    required this.accGroupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'AccountGroupCode': accountGroupCode,
      'accountGroupName': accountGroupName,
      'groupUnder': groupUnder,
      'narration': narration,
      'LedgerNextNo': ledgerNextNo,
      'branchId': branchId,
      'ModifiedUser': modifiedUser,
      'acc_groupId': accGroupId,
    };
  }
}
