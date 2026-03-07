import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/itemwiseReport/data/models/itemwiseReportModel.dart';
import 'package:quikservnew/features/itemwiseReport/data/models/itemwiseReportNewModel.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class ItemWiseReportRemoteDataSource {
  Future<ItemWiseReportModel> fetchItemWiseReport(ItemWiseReportRequest request);
  Future<ItemWiseReportModelNew> fetchItemWiseReportNew(ItemWiseReportRequest request);
}
class ItemWiseReportRemoteDataSourceImpl implements ItemWiseReportRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<ItemWiseReportModel> fetchItemWiseReport(ItemWiseReportRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getFetchItemWiseReportPath(
        baseUrl,
      ); // implement in ApiConstants
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      print('🔹 Save Sale URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

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
      print('🔹 ResponseItemWise data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemWiseReportModel.fromJson(response.data);
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

  @override
  Future<ItemWiseReportModelNew> fetchItemWiseReportNew(ItemWiseReportRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.fetchItemWiseReportNewReportPath(
        baseUrl,
      ); // implement in ApiConstants
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      print('🔹 Save Sale URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

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
      print('🔹 ResponseItemWise data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemWiseReportModelNew.fromJson(response.data);
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