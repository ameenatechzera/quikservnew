import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/domain/usecases/fetchItemwiseReportUseCase.dart';

part 'item_wise_report_state.dart';

class ItemWiseReportCubit extends Cubit<ItemWiseReportState> {
  final FetchItemWiseReportUseCase _fetchItemWiseReportUseCase;
  ItemWiseReportCubit({required FetchItemWiseReportUseCase fetchItemWiseReportUseCase}) : _fetchItemWiseReportUseCase = fetchItemWiseReportUseCase,super(ItemWiseReportInitial());

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

}
