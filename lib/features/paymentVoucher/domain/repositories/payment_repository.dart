import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/paymentVoucherRequest.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';

abstract class PaymentRepository {
  //ResultFuture<FetchProductResponseModel> fetchProducts();
  ResultFuture<MasterResponseModel> savePaymentVoucher(PaymentVoucherRequest request);
  // ResultFuture<MasterResponseModel> deleteProductFromServer(int productCode);
  // ResultFuture<MasterResponseModel> updateProduct(
  //   int productCode,
  //   ProductSaveRequest request,
  // );
}
