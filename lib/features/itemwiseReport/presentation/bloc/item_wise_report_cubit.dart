import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwiseReportNew.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetchItemWiseReportNewUseCase.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetchItemwiseReportUseCase.dart';

part 'item_wise_report_state.dart';

class ItemWiseReportCubit extends Cubit<ItemWiseReportState> {
  final FetchItemWiseReportUseCase _fetchItemWiseReportUseCase;
  final FetchItemWiseReportNewUseCase _fetchItemWiseReportNewUseCase;
  ItemWiseReportCubit({required FetchItemWiseReportUseCase fetchItemWiseReportUseCase, required FetchItemWiseReportNewUseCase fetchItemWiseReportNewUseCase}) : _fetchItemWiseReportUseCase = fetchItemWiseReportUseCase,
        _fetchItemWiseReportNewUseCase = fetchItemWiseReportNewUseCase ,super(ItemWiseReportInitial());

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReport(ItemWiseReportRequest request) async {

    print('ItemWiseReportRequestItem ${request.toJson()}');
    emit(ItemWiseReportInitial());


    try {
      final result = await _fetchItemWiseReportUseCase(request);

      result.fold(
            (failure) {
          emit(ItemSaleReportFailure(failure.message));
        },
            (reportResponse) {
          emit(ItemSaleReportLoaded(itemWisReport: reportResponse.summaryReport));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during Summary Report: $e');
      print('Stacktrace: $stacktrace');
      emit(ItemSaleReportFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReportNew(ItemWiseReportRequest request) async {

    print('ItemWiseReportRequestItem ${request.toJson()}');

    emit(ItemWiseReportInitial());

    try {
      final result = await _fetchItemWiseReportNewUseCase(request);

      result.fold(
            (failure) {
          emit(ItemSaleReportFailure(failure.message));
        },
            (reportResponse) {

          final report = reportResponse.summaryReport;

          if (report != null) {
            emit(ItemSaleReportNewLoaded(itemWisReportNew: report));
          } else {
            emit( ItemSaleReportFailure("No data available"));
          }

        },
      );

    } catch (e, stacktrace) {

      print('❌ Exception during Summary Report: $e');
      print('Stacktrace: $stacktrace');

      emit( ItemSaleReportFailure('An unexpected error occurred'));
    }
  }

}
