import 'package:floor/floor.dart';

class FetchLedgerResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final List<FetchLedgerDetailsEntity>? ledgers;

  FetchLedgerResponseEntity({
    this.status,
    this.error,
    this.message,
    this.ledgers,
  });
}

@Entity(tableName: 'tbl_ledger', primaryKeys: ['ledgerId'])
class FetchLedgerDetailsEntity {
  final int? ledgerId;
  final String? ledgerName;
  final int? groupId;
  final String? openingBalance;
  final String? crOrDr;
  final String? accountNo;
  final String? bankName;
  final int? branchId;
  final String? ledgerCode;
  final String? createdDate;
  final String? createdUser;

  FetchLedgerDetailsEntity({
    this.ledgerId,
    this.ledgerName,
    this.groupId,
    this.openingBalance,
    this.crOrDr,
    this.accountNo,
    this.bankName,
    this.branchId,
    this.ledgerCode,
    this.createdDate,
    this.createdUser,
  });
}
