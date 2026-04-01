import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/usecases/fetch_itemwisedetails_usecase.dart';

import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final FetchItemWiseDetailsUseCase _fetchItemWiseDetailUseCase;
  ItemCubit({required FetchItemWiseDetailsUseCase fetchItemWiseDetailsUseCase})
    : _fetchItemWiseDetailUseCase = fetchItemWiseDetailsUseCase,
      super(ItemInitial());

  // --------------------- API Fetch ---------------------
  Future<void> fetchItemWiseReports(ItemWiseReportRequest request) async {
    emit(ItemWiseDetailInitial());
    try {
      final result = await _fetchItemWiseDetailUseCase(request);

      result.fold(
        (failure) {
          emit(ItemDetailFailure(failure.message));
        },
        (reportResponse) {
          emit(ItemDetailLoaded(itemWisReport: reportResponse.summaryReport));
        },
      );
    } catch (e) {
      emit(ItemDetailFailure('An unexpected error occurred'));
    }
  }
}
