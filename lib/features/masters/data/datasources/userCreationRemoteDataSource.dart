import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/data/models/cashierList_model.dart';
import 'package:quikservnew/features/masters/data/models/supplierList_model.dart';
import 'package:quikservnew/features/masters/data/models/user_types_model.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class UserCreationRemoteDataSource {
  Future<UserTypesModel> fetchUserTypes();
  Future<MasterResponseModel> saveUserTypes(SaveUserParameters request);
  Future<CashierListModel> fetchCashierList();
  Future<SupplierListModel> fetchSupplierList();


}
class UserCreationRemoteDataSourceImpl implements UserCreationRemoteDataSource {

  Dio dio = Dio();
  @override
  Future<UserTypesModel> fetchUserTypes() async {
    try {
      // Get the base URL from shared preferences
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // Build the full API URL
      final url = ApiConstants.getUserTypesPath(baseUrl);
      print('🔹 Fetch UserTypes URL: $url');

      // Get database name and token
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      // Make GET request
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

      // Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // Parse response
      if (response.statusCode == 200) {
        return UserTypesModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during fetchSettings: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> saveUserTypes(SaveUserParameters request) async {
    try {
      // Get the base URL from shared preferences
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // Build the full API URL
      final url = ApiConstants.saveUserPath(baseUrl);
      print('🔹 Save User URL: $url');
      print('request ${request.toJson()}');

      // Get database name and token
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      // Make GET request
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

      // Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // Parse response
      if (response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during fetchSettings: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<CashierListModel> fetchCashierList() async {
    try {
      // Get the base URL from shared preferences
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // Build the full API URL
      final url = ApiConstants.fetchCashierListPath(baseUrl);
      print('🔹 Fetch UserTypes URL: $url');

      // Get database name and token
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      // Make GET request
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

      // Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // Parse response
      if (response.statusCode == 200) {
        return CashierListModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during fetchSettings: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<SupplierListModel> fetchSupplierList() async {
    try {
      // Get the base URL from shared preferences
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // Build the full API URL
      final url = ApiConstants.fetchSupplierListPath(baseUrl);
      print('🔹 Fetch UserTypes URL: $url');

      // Get database name and token
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      // Make GET request
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

      // Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // Parse response
      if (response.statusCode == 200) {
        return SupplierListModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during fetchSettings: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

}