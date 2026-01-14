import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesDetailsByMasterIdUseCase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final SalesDetailsByMasterIdUseCase _salesDetailsByMasterIdUseCase;
  CartCubit({required SalesDetailsByMasterIdUseCase salesDetailsByMasterIdUseCase,}) :
        _salesDetailsByMasterIdUseCase = salesDetailsByMasterIdUseCase,super(CartInitial());

  // --------------------- API Fetch SalesDetails By MasterId ---------------------
  Future<void> fetchSalesDetailsByMasterId(
      FetchSalesDetailsRequest request,
      ) async {
    emit(SlesDetailsFromCartInitial());

    try {
      final response = await _salesDetailsByMasterIdUseCase(request);

      response.fold(
            (failure) => emit(SalesReportFromCartError(error: failure.message)),
            (saleResponse) => emit(SalesDetailsFromCartSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SalesReportFromCartError(error: e.toString()));
    }
  }
}
