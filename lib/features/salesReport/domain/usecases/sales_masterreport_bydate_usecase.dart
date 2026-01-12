import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';

class SalesReportMasterByDateUseCase
    implements
        UseCaseWithParams<SalesReportResult, SalesReportMasterByDateRequest> {
  final SalesReportRepository _repository;

  SalesReportMasterByDateUseCase(this._repository);

  @override
  ResultFuture<SalesReportResult> call(SalesReportMasterByDateRequest params) {
    return _repository.fetchSalesReportMasterByDate(params);
  }
}
