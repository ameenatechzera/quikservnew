import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/delete_salesparameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';

abstract class SalesReportRepository {
  ResultFuture<SalesReportResult> fetchSalesReport(FetchReportRequest request);
  ResultFuture<SalesDetailsByMasterIdResult> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  );
  ResultFuture<MasterResult> deleteSalesFromServer(
      SalesDeleteByMasterIdRequest SalesDeleteRequest);
  ResultFuture<SalesReportResult> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  );
}
