import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/save_paymentvoucher_parameter.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class PaymentRemoteDataSource {
  Future<MasterResponseModel> savePaymentVoucher(
    SavePaymentVoucherParameter request,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<MasterResponseModel> savePaymentVoucher(
    SavePaymentVoucherParameter params,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.savePaymentVoucherPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      // 🔍 Debug logs
      print('🔹 Save Payment Voucher URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');
      print('🔹 Request Body: ${params.toJson()}');

      final response = await dio.post(
        url,
        data: params.toJson(),
        options: Options(
          contentType: "application/json",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
          },
        ),
      );

      print('🔹 Response status: ${response.statusCode}');
      print('🔹 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in savePaymentVoucher: $e');
      print(s);
      rethrow;
    }
  }
}
