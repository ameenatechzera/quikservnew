import 'package:quikservnew/features/masters/domain/entities/cashierlist_result.dart';

class CashierListModel extends CashierListResponse{
  CashierListModel({required super.status, required super.error, required super.message, required super.details});

  factory CashierListModel.fromJson(Map<String, dynamic> json){
    return CashierListModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      details: json["details"] == null ? [] : List<CashierList>.from(json["details"]!.map((x) => CashierList.fromJson(x))),
    );
  }
}