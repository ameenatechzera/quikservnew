import 'package:quikservnew/features/accountledger/domain/entities/fetch_accountledger_entity.dart';

class FetchLedgerResponseModel extends FetchLedgerResponseEntity {
  FetchLedgerResponseModel({
    super.status,
    super.error,
    super.message,
    List<FetchLedgerDetailsModel>? super.ledgers,
  });

  factory FetchLedgerResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchLedgerResponseModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      ledgers: json['data'] != null
          ? List<FetchLedgerDetailsModel>.from(
              json['data'].map((x) => FetchLedgerDetailsModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "error": error,
      "message": message,
      "data": ledgers
          ?.map((x) => (x as FetchLedgerDetailsModel).toJson())
          .toList(),
    };
  }
}

class FetchLedgerDetailsModel extends FetchLedgerDetailsEntity {
  FetchLedgerDetailsModel({
    super.ledgerId,
    super.ledgerName,
    super.groupId,
    super.openingBalance,
    super.crOrDr,
    super.accountNo,
    super.bankName,
    super.branchId,
    super.ledgerCode,
    super.createdDate,
    super.createdUser,
  });

  factory FetchLedgerDetailsModel.fromJson(Map<String, dynamic> json) {
    return FetchLedgerDetailsModel(
      ledgerId: json['ledgerId'],
      ledgerName: json['ledgerName'],
      groupId: json['groupId'],
      openingBalance: json['openingBalance'],
      crOrDr: json['crOrDr'],
      accountNo: json['accountNo'],
      bankName: json['bankname'],
      branchId: json['branchId'],
      ledgerCode: json['ledgerCode'],
      createdDate: json['CreatedDate'],
      createdUser: json['CreatedUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ledgerId": ledgerId,
      "ledgerName": ledgerName,
      "groupId": groupId,
      "openingBalance": openingBalance,
      "crOrDr": crOrDr,
      "accountNo": accountNo,
      "bankname": bankName,
      "branchId": branchId,
      "ledgerCode": ledgerCode,
      "CreatedDate": createdDate,
      "CreatedUser": createdUser,
    };
  }
}
