import 'package:quikservnew/features/paymentVoucher/domain/entities/payment_voucher_response.dart';

class PaymentVoucherModel extends PaymentVoucherResponse {
  PaymentVoucherModel({
    required super.status,
    required super.error,
    required super.message,
    required super.data,
  });

  factory PaymentVoucherModel.fromJson(Map<String, dynamic> json) {
    return PaymentVoucherModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}
