import 'package:quikservnew/features/masters/domain/entities/supplierlist_result.dart';

class SupplierListModel extends SupplierListResponse{
  SupplierListModel({required super.status, required super.error, required super.message, required super.details});

  factory SupplierListModel.fromJson(Map<String, dynamic> json){
    return SupplierListModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      details: json["details"] == null ? [] : List<SupplierList>.from(json["details"]!.map((x) => SupplierList.fromJson(x))),
    );
  }
}