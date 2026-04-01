import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_reportnew.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetch_itemwisereportnew_usecase.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetch_itemwisereport_usecase.dart';

part 'item_wise_report_state.dart';

class ItemWiseReportCubit extends Cubit<ItemWiseReportState> {
  final FetchItemWiseReportUseCase _fetchItemWiseReportUseCase;
  final FetchItemWiseReportNewUseCase _fetchItemWiseReportNewUseCase;
  ItemWiseReportCubit({
    required FetchItemWiseReportUseCase fetchItemWiseReportUseCase,
    required FetchItemWiseReportNewUseCase fetchItemWiseReportNewUseCase,
  }) : _fetchItemWiseReportUseCase = fetchItemWiseReportUseCase,
       _fetchItemWiseReportNewUseCase = fetchItemWiseReportNewUseCase,
       super(ItemWiseReportInitial());

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReport(ItemWiseReportRequest request) async {
    emit(ItemWiseReportInitial());
    try {
      final result = await _fetchItemWiseReportUseCase(request);
      result.fold(
        (failure) {
          emit(ItemSaleReportFailure(failure.message));
        },
        (reportResponse) {
          emit(
            ItemSaleReportLoaded(itemWisReport: reportResponse.summaryReport),
          );
        },
      );
    } catch (e) {
      emit(ItemSaleReportFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReportNew(ItemWiseReportRequest request) async {
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
            emit(ItemSaleReportFailure("No data available"));
          }
        },
      );
    } catch (e) {
      emit(ItemSaleReportFailure('An unexpected error occurred'));
    }
  }
}
