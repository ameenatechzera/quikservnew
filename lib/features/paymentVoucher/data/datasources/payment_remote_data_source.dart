import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/paymentVoucher/data/models/paymentVoucherModel.dart';
import 'package:quikservnew/features/paymentVoucher/domain/entities/paymentVoucherResponse.dart';
import 'package:quikservnew/features/paymentVoucher/domain/parameters/paymentVoucherRequest.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class PaymentRemoteDataSource {
  Future<MasterResponseModel> savePaymentVoucher(PaymentVoucherRequest request);


}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  Dio dio = Dio();

  @override
  savePaymentVoucher(PaymentVoucherRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      print(dbName);
      print(token);
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      final url = ApiConstants.saveProductPath(baseUrl);
      // 🔹 Print the data being sent

      final response = await dio.post(
        url,

        options: Options(
          contentType: "application/json",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
          },
        ),
      );

      print('Save Product Status: ${response.statusCode}');
      print('Save Product Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ success – nothing to return
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      throw Exception("Error saving product: $e");
    }
  }
}