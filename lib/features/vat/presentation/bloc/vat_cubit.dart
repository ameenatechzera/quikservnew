import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/usecases/fetch_vat_usecase.dart';

part 'vat_state.dart';

class VatCubit extends Cubit<VatState> {
  final FetchVatUseCase _fetchVatUseCase;

  VatCubit({required FetchVatUseCase fetchVatUseCase})
    : _fetchVatUseCase = fetchVatUseCase,
      super(VatInitial());

  /// 🔥 Call this method to fetch VAT
  Future<void> fetchVat() async {
    emit(VatLoading());

    final response = await _fetchVatUseCase();

    response.fold(
      (failure) => emit(VatError(error: failure.message)),
      (response) => emit(VatLoaded(vat: response)),
    );
  }
}
