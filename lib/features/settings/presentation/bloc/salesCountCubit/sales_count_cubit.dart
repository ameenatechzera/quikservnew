import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/customSalesGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchCustomSalesAmountGraphUseCase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetchSalesCountGraphUseCase.dart';

part 'sales_count_state.dart';

class SalesCountCubit extends Cubit<SalesCountState> {
  final FetchSalesCountGraphReportUseCase _fetchSalesCountGraphReportUseCase;
  final FetchCustomSalesAmountGraphReportUseCase _fetchCustomSalesAmountGraphReportUseCase;

  SalesCountCubit({required FetchSalesCountGraphReportUseCase fetchSalesCountGraphReportUseCase ,
    required FetchCustomSalesAmountGraphReportUseCase fetchCustomSalesAmountGraphReportUseCase}) :
        _fetchSalesCountGraphReportUseCase = fetchSalesCountGraphReportUseCase,_fetchCustomSalesAmountGraphReportUseCase = fetchCustomSalesAmountGraphReportUseCase,super(SalesCountInitial());

  Future<void> fetchSalesCountFromServer(BarGraphRequest request) async {
    print('SalesCountRequese ${request.toJson()}');
    emit(FetchSales_CountGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchSalesCountGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

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

  Future<void> fetchCustomSalesGraphFromServer(CustomSalesGraphRequest request) async {
    print('CustomSalesGraphRequest ${request.toString()}');
    emit(FetchCustom_SalesGraphLoading());
    try {
      print('reached cubit');
      final response = await _fetchCustomSalesAmountGraphReportUseCase(request);
      log(response.toString(), name: 'result_settings');

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
