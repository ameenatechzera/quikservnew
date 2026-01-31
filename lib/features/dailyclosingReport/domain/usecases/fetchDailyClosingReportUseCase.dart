import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/repositories/dailyClosingReportRepository.dart';


class FetchDailyClosingReportUseCase implements UseCaseWithParams<DailyClosingReportResponse, DailyCloseReportRequest> {

  final DailyClosingReportRepository _dailyClosingReportRepository;

  FetchDailyClosingReportUseCase(this._dailyClosingReportRepository);

  @override
  ResultFuture<DailyClosingReportResponse> call(DailyCloseReportRequest request) async => _dailyClosingReportRepository.fetchDailyClosingReport(request);
}