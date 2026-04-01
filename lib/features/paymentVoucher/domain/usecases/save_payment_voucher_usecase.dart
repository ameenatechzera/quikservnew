import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/save_paymentvoucher_parameter.dart';
import 'package:quikservnew/features/paymentVoucher/domain/repositories/payment_repository.dart';

class SavePaymentVoucherUseCase
    implements
        UseCaseWithParams<MasterResponseModel, SavePaymentVoucherParameter> {
  final PaymentRepository _homeRepository;
  SavePaymentVoucherUseCase(this._homeRepository);

  @override
  ResultFuture<MasterResponseModel> call(
    SavePaymentVoucherParameter request,
  ) async => _homeRepository.savePaymentVoucher(request);
}
