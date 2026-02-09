import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/paymentVoucherRequest.dart';
import 'package:quikservnew/features/paymentVoucher/domain/repositories/payment_repository.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';

class SavePaymentVoucherUseCase implements UseCaseWithParams<MasterResponseModel, PaymentVoucherRequest> {

  final PaymentRepository _homeRepository;
  SavePaymentVoucherUseCase(this._homeRepository);

  @override
  ResultFuture<MasterResponseModel> call(PaymentVoucherRequest request) async => _homeRepository.savePaymentVoucher(request);
}