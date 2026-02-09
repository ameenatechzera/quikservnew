import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';

class paymentVoucherModel extends PaymentVoucherResponse{
  paymentVoucherModel({required super.status, required super.error, required super.message, required super.data});

  factory paymentVoucherModel.fromJson(Map<String, dynamic> json){
    return paymentVoucherModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}