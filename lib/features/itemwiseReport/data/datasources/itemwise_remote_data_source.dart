import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/itemwiseReport/data/models/itemwise_report_model.dart';
import 'package:quikservnew/features/itemwiseReport/data/models/itemwise_report_new_model.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class ItemWiseReportRemoteDataSource {
  Future<ItemWiseReportModel> fetchItemWiseReport(
    ItemWiseReportRequest request,
  );
  Future<ItemWiseReportModelNew> fetchItemWiseReportNew(
    ItemWiseReportRequest request,
  );
}

class ItemWiseReportRemoteDataSourceImpl
    implements ItemWiseReportRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<ItemWiseReportModel> fetchItemWiseReport(
    ItemWiseReportRequest request,
  ) async {
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemWiseReportModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ItemWiseReportModelNew> fetchItemWiseReportNew(
    ItemWiseReportRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.fetchItemWiseReportNewReportPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ItemWiseReportModelNew.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
