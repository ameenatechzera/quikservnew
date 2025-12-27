import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/repositories/salesReport_repository.dart';

class SalesReportFromServerUseCase
    implements UseCaseWithParams<SalesReportResult, FetchReportRequest> {
  final SalesReportRepository _salesReportRepository;

  SalesReportFromServerUseCase(this._salesReportRepository);

  @override
  ResultFuture<SalesReportResult> call(FetchReportRequest params) async {
    return _salesReportRepository.fetchSalesReport(params);
  }
}
