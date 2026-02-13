import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetchItemWiseDetailsUseCase.dart';

import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final FetchItemWiseDetailsUseCase _fetchItemWiseDetailUseCase;
  ItemCubit({required FetchItemWiseDetailsUseCase fetchItemWiseDetailsUseCase}) : _fetchItemWiseDetailUseCase = fetchItemWiseDetailsUseCase, super(ItemInitial());


  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReports(ItemWiseReportRequest request) async {
    print('ItemWiseReportRequest ${request.toJson()}');
    emit(ItemWiseDetailInitial());


    try {
      final result = await _fetchItemWiseDetailUseCase(request);

      result.fold(
            (failure) {
          emit(ItemDetailFailure(failure.message));
        },
            (reportResponse) {
          print('reportResponse ${reportResponse.toJson()}');
          emit(ItemDetailLoaded(itemWisReport: reportResponse.summaryReport));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during Summary Report: $e');
      print('Stacktrace: $stacktrace');
      emit(ItemDetailFailure('An unexpected error occurred'));
    }
  }
}
