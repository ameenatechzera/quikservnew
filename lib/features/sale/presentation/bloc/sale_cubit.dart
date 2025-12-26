import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';
import 'package:quikservnew/features/sale/domain/usecases/save_sale_toserver_usecase.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  final SaveSaleUseCase _saveSaleUseCase;
  final SalesRepository _salesRepository;
  int selectedTabIndex = 0;
  SaleCubit({
    required SaveSaleUseCase saveSaleUseCase,
    required SalesRepository salesRepository,
  }) : _saveSaleUseCase = saveSaleUseCase,
       _salesRepository = salesRepository,
       super(SaleInitial());

  void selectTab(int index) {
    selectedTabIndex = index;
    emit(SaleTabChanged(index));
  }

  // --------------------- API Save Sale ---------------------
  Future<void> saveSale(SaveSaleRequest request) async {
    emit(SaleLoading());

    try {
      final response = await _saveSaleUseCase(request);

      response.fold(
        (failure) => emit(SaleError(error: failure.message)),
        (saleResponse) => emit(SaleSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SaleError(error: e.toString()));
    }
  }
}
