import 'package:quikservnew/features/salesReport/domain/entities/salesreport_result.dart';

class SalesReportModel extends SalesReportResult {
  const SalesReportModel({
    required super.status,
    required super.error,
    required super.message,
    required super.salesMaster,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      salesMaster: json["sales_master"] == null
          ? []
          : List<SalesMaster>.from(
              json["sales_master"]!.map((x) => SalesMaster.fromJson(x)),
            ),
    );
  }
  SalesReportResult toEntity() {
    return SalesReportResult(
      status: status,
      error: error,
      message: message,
      salesMaster: [],
    );
  }
}
