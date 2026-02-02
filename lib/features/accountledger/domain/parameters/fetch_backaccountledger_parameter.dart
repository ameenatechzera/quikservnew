class FetchBankAccountLedgerParams {
  final List<int> groupIds;

  FetchBankAccountLedgerParams({required this.groupIds});

  Map<String, dynamic> toJson() {
    return {"group_ids": groupIds};
  }
}
