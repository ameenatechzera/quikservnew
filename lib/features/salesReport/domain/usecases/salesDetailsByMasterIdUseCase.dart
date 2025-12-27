import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';

class SalesDetailsByMasterIdUseCase
    implements UseCaseWithParams<SalesDetailsByMasterIdResult, FetchSalesDetailsRequest> {
  final SalesReportRepository _salesReportRepository;

  SalesDetailsByMasterIdUseCase(this._salesReportRepository);

  @override
  ResultFuture<SalesDetailsByMasterIdResult> call(FetchSalesDetailsRequest params) async {
    return _salesReportRepository.fetchSalesDetailsByMasterId(params);
  }
}