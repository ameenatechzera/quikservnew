import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/save_paymentvoucher_parameter.dart';

abstract class PaymentRepository {
  ResultFuture<MasterResponseModel> savePaymentVoucher(
    SavePaymentVoucherParameter request,
  );
}
