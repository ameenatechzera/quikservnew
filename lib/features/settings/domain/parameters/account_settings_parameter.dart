class AccountSettingsParams {
  final int cashLedgerId;
  final int cardLedgerId;
  final int bankLedgerId;

  AccountSettingsParams({
    required this.cashLedgerId,
    required this.cardLedgerId,
    required this.bankLedgerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "cash_ledger_id": cashLedgerId,
      "card_ledger_id": cardLedgerId,
      "bank_ledger_id": bankLedgerId,
    };
  }
}
