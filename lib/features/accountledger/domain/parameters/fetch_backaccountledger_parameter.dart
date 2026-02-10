class FetchBankAccountLedgerParams {
  final List<int> groupIds;
  final int branchId;

  FetchBankAccountLedgerParams({
    required this.groupIds,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {"group_ids": groupIds, "branchId": branchId};
  }
}
