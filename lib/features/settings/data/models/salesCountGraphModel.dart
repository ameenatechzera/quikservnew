import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';

class SalesCountGraphModel extends SalesCountGraphResult{
  SalesCountGraphModel({required super.status, required super.error, required super.period, required super.data});

  factory SalesCountGraphModel.fromJson(Map<String, dynamic> json){
    return SalesCountGraphModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      period: json["period"] ?? "",
      data: json["data"] == null ? [] : List<SaleCountGraphList>.from(json["data"]!.map((x) => SaleCountGraphList.fromJson(x))),
    );
  }
}