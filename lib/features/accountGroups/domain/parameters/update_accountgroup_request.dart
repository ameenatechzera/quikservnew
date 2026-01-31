
/// Model for updating a Account Group
class UpdateAccountGroupRequest {
final String AccountGroupCode;
final String accountGroupName;
final String groupUnder;
final String narration;
final String LedgerNextNo;
final String branchId;
final String ModifiedUser;
final String acc_groupId;


UpdateAccountGroupRequest({
required this.AccountGroupCode,
required this.accountGroupName,
required this.groupUnder,
required this.narration,
required this.LedgerNextNo,
required this.branchId,
required this.ModifiedUser,
  required this.acc_groupId

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
'ModifiedUser': ModifiedUser,
  'acc_groupId':acc_groupId

};
}
}
