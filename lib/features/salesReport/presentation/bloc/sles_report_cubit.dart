import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesDetailsByMasterIdUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesReportFromServerUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/sales_masterreport_bydate_usecase.dart';

part 'sles_report_state.dart';

class SalesReportCubit extends Cubit<SlesReportState> {
  final SalesReportFromServerUseCase _salesReportFromServerUseCase;
  final SalesDetailsByMasterIdUseCase _salesDetailsByMasterIdUseCase;
  final SalesReportMasterByDateUseCase _salesReportMasterByDateUseCase;

  SalesReportCubit({
    required SalesReportFromServerUseCase salesReportFromServerUseCase,
    required SalesDetailsByMasterIdUseCase salesDetailsByMasterIdUseCase,
    required SalesReportMasterByDateUseCase salesReportMasterByDateUseCase,
  }) : _salesReportFromServerUseCase = salesReportFromServerUseCase,
       _salesDetailsByMasterIdUseCase = salesDetailsByMasterIdUseCase,
       _salesReportMasterByDateUseCase = salesReportMasterByDateUseCase,
       super(SlesReportInitial());

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
  Future<void> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  ) async {
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

  // --------------------- API Fetch Bill Save_finished ---------------------
  Future<void> saleSaveFinished(int seconds_timer) async {
    await Future.delayed(Duration(seconds: seconds_timer));
    emit(SaleFinishSuccess(response: 'success'));
  }
  // --------------------- API Fetch SalesReport Master By Date ---------------------

  Future<void> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  ) async {
    emit(SalesReportMasterByDateInitial());

    try {
      final response = await _salesReportMasterByDateUseCase(request);

      response.fold(
        (failure) => emit(SalesReportMasterByDateError(error: failure.message)),
        (saleResponse) {
          final salesList = saleResponse.salesMaster;

          final totalSalesCount = salesList.length;

          final totalSalesAmount = salesList.fold<double>(
            0.0,
            (sum, item) =>
                sum + (double.tryParse(item.grandTotal.toString()) ?? 0.0),
          );

          final cashBalance = salesList.fold<double>(
            0.0,
            (sum, item) =>
                sum + (double.tryParse(item.cashAmount.toString()) ?? 0.0),
          );

          emit(
            SalesReportMasterByDateSuccess(
              response: saleResponse,
              totalSalesCount: totalSalesCount,
              totalSalesAmount: totalSalesAmount,
              cashBalance: cashBalance,
            ),
          );
        },
      );
    } catch (e) {
      emit(SalesReportMasterByDateError(error: e.toString()));
    }
  }
}
