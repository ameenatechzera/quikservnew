import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/settings/domain/entities/weekly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/repositories/settings_repository.dart';

class FetchWeeklyGraphReportUseCase
    implements UseCaseWithParams<WeeklyGraphReportResult, BarGraphRequest> {
  final SettingsRepository _generalRepository;

  FetchWeeklyGraphReportUseCase(this._generalRepository);

  @override
  ResultFuture<WeeklyGraphReportResult> call(BarGraphRequest request) async =>
      _generalRepository.fetchWeeklyGraphReport(request);
}
