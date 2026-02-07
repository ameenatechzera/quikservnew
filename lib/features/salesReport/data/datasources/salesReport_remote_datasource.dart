import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/salesReport/data/models/salesDetailsByMasterIdModel.dart';
import 'package:quikservnew/features/salesReport/data/models/salesReport_response_model.dart';
import 'package:quikservnew/features/salesReport/domain/entities/masterResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/delete_salesparameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class SalesReportRemoteDataSource {
  Future<SalesReportModel> fetchSalesReport(FetchReportRequest request);
  Future<salesDetailsByMasterIdModel> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  );
  Future<SalesReportModel> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  );
  Future<MasterResult> deleteSalesFromServer(
      SalesDeleteByMasterIdRequest salesDeleteRequest);
}

class SalesReportRemoteDataSourceImpl implements SalesReportRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<SalesReportModel> fetchSalesReport(FetchReportRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getFetchSalesReportPath(
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
      print('🔹 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SalesReportModel.fromJson(response.data);
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
  Future<salesDetailsByMasterIdModel> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getFetchSalesDetailsReportPath(
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
      print('🔹 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return salesDetailsByMasterIdModel.fromJson(response.data);
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
  Future<SalesReportModel> fetchSalesReportMasterByDate(
    SalesReportMasterByDateRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getFetchSalesReportPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      print('🔹 Fetch Sales Report by Date URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');
      print('🔹 Token : ${token}');

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
        return SalesReportModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in fetchSalesReportMasterByDate: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResult> deleteSalesFromServer(SalesDeleteByMasterIdRequest salesDeleteRequest) async {

      try {
        final baseUrl = await SharedPreferenceHelper().getBaseUrl();
        if (baseUrl == null || baseUrl.isEmpty) {
          throw Exception("Base URL not set");
        }

        final url = ApiConstants.deleteSalesByMasterIdPath(baseUrl,salesDeleteRequest.masterId);
        final dbName = await SharedPreferenceHelper().getDatabaseName();
        final token = await SharedPreferenceHelper().getToken() ?? "";

        print('🔹 Fetch Sales Report by Date URL: $url');
        print('🔹 DB Name: $dbName');
        print('🔹 Token exists: ${token.isNotEmpty}');

        if (token.isEmpty) throw Exception("Token missing! Please login again.");

        final response = await dio.get(
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

        print('🔹 Response status: ${response.statusCode}');
        print('🔹 Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return MasterResult.fromJson(response.data);
        } else {
          throw ServerException(
            errorMessageModel: ErrorMessageModel.fromJson(response.data),
          );
        }
      } catch (e, s) {
        print('❌ Exception in fetchSalesReportMasterByDate: $e');
        print(s);
        rethrow;
      }
    }
}
