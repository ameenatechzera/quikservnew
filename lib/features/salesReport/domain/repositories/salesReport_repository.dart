import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/domain/entities/master_result.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesreport_result.dart';
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
    SalesDeleteByMasterIdRequest SalesDeleteRequest,
  );
  ResultFuture<SalesReportResult> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  );
}
