import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesDetailsByMasterIdUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesReportFromServerUseCase.dart';

part 'sles_report_state.dart';

class SalesReportCubit extends Cubit<SlesReportState> {
  final SalesReportFromServerUseCase _salesReportFromServerUseCase;
  final SalesDetailsByMasterIdUseCase _salesDetailsByMasterIdUseCase;
  SalesReportCubit({ required SalesReportFromServerUseCase salesReportFromServerUseCase ,
  required SalesDetailsByMasterIdUseCase salesDetailsByMasterIdUseCase }) : _salesReportFromServerUseCase = salesReportFromServerUseCase,
        _salesDetailsByMasterIdUseCase = salesDetailsByMasterIdUseCase, super(SlesReportInitial());

  // --------------------- API Fetch SalesReport ---------------------
  Future<void> fetchSalesReport(FetchReportRequest request) async {
    emit(SlesReportInitial());

    try {
      final response = await _salesReportFromServerUseCase(request);

      response.fold(
            (failure) => emit(SalesReportError(error: failure.message)),
            (saleResponse) => emit(SalesReportSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SalesReportError(error: e.toString()));
    }
  }

  // --------------------- API Fetch SalesDetails By MasterId ---------------------
  Future<void> fetchSalesDetailsByMasterId(FetchSalesDetailsRequest request) async {
    emit(SlesDetailsInitial());

    try {
      final response = await _salesDetailsByMasterIdUseCase(request);

      response.fold(
            (failure) => emit(SalesDetailsError(error: failure.message)),
            (saleResponse) => emit(SalesDetailsSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SalesDetailsError(error: e.toString()));
    }
  }
}
