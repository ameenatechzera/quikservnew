import 'package:quikservnew/features/accountledger/domain/entities/account_ledger_entity.dart';

class AccountLedgerModel  extends AccountLedgerResponse{
  AccountLedgerModel({required super.status, required super.error, required super.message, required super.data});

  factory AccountLedgerModel.fromJson(Map<String, dynamic> json){
    return AccountLedgerModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}