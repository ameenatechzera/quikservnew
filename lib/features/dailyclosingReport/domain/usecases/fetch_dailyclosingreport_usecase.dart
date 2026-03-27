import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyclosingreport_result.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyclosingreport_request.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/repositories/dailyclosingreport_repository.dart';

class FetchDailyClosingReportUseCase
    implements
        UseCaseWithParams<DailyClosingReportResponse, DailyCloseReportRequest> {
  final DailyClosingReportRepository _dailyClosingReportRepository;

  FetchDailyClosingReportUseCase(this._dailyClosingReportRepository);

  @override
  ResultFuture<DailyClosingReportResponse> call(
    DailyCloseReportRequest request,
  ) async => _dailyClosingReportRepository.fetchDailyClosingReport(request);
}
