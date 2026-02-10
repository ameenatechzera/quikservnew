import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/save_paymentvoucher_parameter.dart';
import 'package:quikservnew/features/paymentVoucher/domain/usecases/savePaymentVoucherUseCase.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final SavePaymentVoucherUseCase _savePaymentVoucherUseCase;
  PaymentCubit({required SavePaymentVoucherUseCase savePaymentVoucherUseCase})
    : _savePaymentVoucherUseCase = savePaymentVoucherUseCase,
      super(PaymentInitial());
  Future<void> savePaymentVoucher(SavePaymentVoucherParameter request) async {
    emit(PaymentInitial());

    final response = await _savePaymentVoucherUseCase(request);

    response.fold(
      (failure) => emit(SavePaymentFailure(failure.message)),
      (response) => emit(SavePaymentSuccess(response: response)),
    );
  }
}
