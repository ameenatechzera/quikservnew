import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/paymentVoucherRequest.dart';
import 'package:quikservnew/features/paymentVoucher/domain/usecases/savePaymentVoucherUseCase.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final SavePaymentVoucherUseCase _savePaymentVoucherUseCase;
  PaymentCubit({required SavePaymentVoucherUseCase savePaymentVoucherUseCase}) : _savePaymentVoucherUseCase = savePaymentVoucherUseCase, super(PaymentInitial());
  Future<void> savePaymentVoucher(PaymentVoucherRequest request) async {
    emit(PaymentInitial());

    final response = await _savePaymentVoucherUseCase(request);

    response.fold(
          (failure) => emit(SavePaymentFailure( failure.message)),
          (response) => emit(SavePaymentSuccess(response: response)),
    );
  }

}
