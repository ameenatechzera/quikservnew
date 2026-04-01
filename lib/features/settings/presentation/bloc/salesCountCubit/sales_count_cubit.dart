import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_customsalesamountgraph_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_salescountgraph_usecase.dart';

part 'sales_count_state.dart';

class SalesCountCubit extends Cubit<SalesCountState> {
  final FetchSalesCountGraphReportUseCase _fetchSalesCountGraphReportUseCase;
  final FetchCustomSalesAmountGraphReportUseCase
  _fetchCustomSalesAmountGraphReportUseCase;

  SalesCountCubit({
    required FetchSalesCountGraphReportUseCase
    fetchSalesCountGraphReportUseCase,
    required FetchCustomSalesAmountGraphReportUseCase
    fetchCustomSalesAmountGraphReportUseCase,
  }) : _fetchSalesCountGraphReportUseCase = fetchSalesCountGraphReportUseCase,
       _fetchCustomSalesAmountGraphReportUseCase =
           fetchCustomSalesAmountGraphReportUseCase,
       super(SalesCountInitial());

  Future<void> fetchSalesCountFromServer(BarGraphRequest request) async {
    emit(FetchSales_CountGraphLoading());
    try {
      final response = await _fetchSalesCountGraphReportUseCase(request);
      response.fold(
        (failure) async {
          log("failure");
          emit(FetchSales_CountGraphError(failure.message));
        },
        (success) {
          emit(FetchSales_CountGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchSales_CountGraphError('An error occurred: $e'));
    }
  }

  Future<void> fetchCustomSalesGraphFromServer(
    CustomSalesGraphRequest request,
  ) async {
    emit(FetchCustom_SalesGraphLoading());
    try {
      final response = await _fetchCustomSalesAmountGraphReportUseCase(request);
      response.fold(
        (failure) async {
          log("failure");
          emit(FetchCustom_SalesGraphError(failure.message));
        },
        (success) {
          emit(FetchCustom_SalesGraphSuccess(success));
        },
      );
    } catch (e) {
      emit(FetchCustom_SalesGraphError('An error occurred: $e'));
    }
  }
}
