import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetchDailyClosingReportUseCase.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetchItemWiseDetailsUseCase.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

part 'dayclose_report_state.dart';

class DaycloseReportCubit extends Cubit<DaycloseReportState> {

  final FetchDailyClosingReportUseCase _fetchDailyClosingReportUseCase;
  final FetchItemWiseDetailsUseCase _fetchItemWiseDetailsUseCase;
  DaycloseReportCubit({required FetchDailyClosingReportUseCase fetchDailyClosingReportUseCase ,required FetchItemWiseDetailsUseCase fetchItemWiseDetailsUseCase}) :
        _fetchDailyClosingReportUseCase = fetchDailyClosingReportUseCase, _fetchItemWiseDetailsUseCase = fetchItemWiseDetailsUseCase,super(DaycloseReportInitial());

  // --------------------- API Fetch ---------------------
  Future<void> fetchDayCloseReport(DailyCloseReportRequest request) async {
    emit(DaycloseReportInitial());


    try {
      final result = await _fetchDailyClosingReportUseCase(request);

      result.fold(
            (failure) {
          emit(DayCloseReportFailure(failure.message));
        },
            (reportResponse) {
          emit(DayCloseReportLoaded(dayCloseReport: reportResponse));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during Summary Report: $e');
      print('Stacktrace: $stacktrace');
      emit(DayCloseReportFailure('An unexpected error occurred'));
    }

  }

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReport(ItemWiseReportRequest request) async {
    print('ItemWiseReportRequest ${request.toJson()}');
    emit(ItemWiseDetailsInitial());


    try {
      final result = await _fetchItemWiseDetailsUseCase(request);

      result.fold(
            (failure) {
          emit(ItemDetailsFailure(failure.message));
        },
            (reportResponse) {
          emit(ItemDetailsLoaded(itemWisReport: reportResponse.summaryReport));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during Summary Report: $e');
      print('Stacktrace: $stacktrace');
      emit(ItemDetailsFailure('An unexpected error occurred'));
    }
  }
}
