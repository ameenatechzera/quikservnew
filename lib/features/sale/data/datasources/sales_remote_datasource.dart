import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/sale/data/models/sale_save_response_model.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class SalesRemoteDataSource {
  Future<SalesResponseModel> saveSale(SaveSaleRequest request);
}

class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<SalesResponseModel> saveSale(SaveSaleRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getSaveSalePath(
        baseUrl,
      ); // implement in ApiConstants
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      print('🔹 Save Sale URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

      /// 🔹 PRINT REQUEST BODY
      final requestBody = request.toJson();
      print('📤 Save Sale Request Body:');
      print(const JsonEncoder.withIndent('  ').convert(requestBody));

      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      final response = await dio.post(
        url,
        data: request.toJson(),
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
        return SalesResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in saveSale: $e');
      print(s);
      rethrow;
    }
  }
}
