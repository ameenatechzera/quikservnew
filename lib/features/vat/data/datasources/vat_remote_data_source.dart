import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class VatRemoteDataSource {
  Future<FetchVatResponseModel> fetchVat();
  Future<MasterResponseModel> addVat(AddVatRequestModel request);
  Future<MasterResponseModel> deleteVatFromServer(int vatId);

  /// 🔹 UPDATE VAT
  Future<MasterResponseModel> updateVatOnServer(
    int vatId,
    EditVatRequestModel request,
  );
}

class VatRemoteDataSourceImpl implements VatRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<FetchVatResponseModel> fetchVat() async {
    print('called');
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      print('ongoing');
      final url = ApiConstants.getVatPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");
      print('ongoing2');

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
      print('ongoingdone');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        return FetchVatResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print("❌ Exception in fetchVat: $e");
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> addVat(AddVatRequestModel request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.addVatPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

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
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ================= DELETE VAT =================
  @override
  Future<MasterResponseModel> deleteVatFromServer(int vatId) async {
    try {
      // 🔹 Get base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // 🔹 Build API URL (vatId appended)
      final url = ApiConstants.deleteVatPath(baseUrl, vatId);
      print('🔹 Delete VAT URL: $url');

      // 🔹 Get headers data
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      // 🔹 DELETE request
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

      // 🔹 Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // 🔹 Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during deleteVat: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  /// ================= UPDATE VAT =================
  @override
  Future<MasterResponseModel> updateVatOnServer(
    int vatId,
    EditVatRequestModel request,
  ) async {
    try {
      // 🔹 Get base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // 🔹 Build API URL (vatId appended)
      final url = ApiConstants.editVatPath(baseUrl, vatId);
      print('🔹 Update VAT URL: $url');

      // 🔹 Headers
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      // 🔹 POST / PUT request (use POST if backend expects POST)
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

      // 🔹 Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // 🔹 Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during updateVat: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }
}
