import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';

class salesDetailsByMasterIdModel extends SalesDetailsByMasterIdResult{
  salesDetailsByMasterIdModel({required super.status, required super.error, required super.message, required super.salesMaster, required super.salesDetails});
  factory salesDetailsByMasterIdModel.fromJson(Map<String, dynamic> json){
    return salesDetailsByMasterIdModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      salesMaster: json["sales_master"] == null ? null : SalesMaster.fromJson(json["sales_master"]),
      salesDetails: json["sales_details"] == null ? [] : List<SalesDetail>.from(json["sales_details"]!.map((x) => SalesDetail.fromJson(x))),
    );
  }
}