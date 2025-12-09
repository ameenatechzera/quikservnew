import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class UnitsRemoteDataSource {
  Future<FetchUnitResponseModel> fetchUnits();
}

class UnitsRemoteDataSourceImpl implements UnitsRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<FetchUnitResponseModel> fetchUnits() async {
    try {
      // Get the base URL from shared preferences
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // Build the full API URL
      final url = ApiConstants.getUnitsPath(baseUrl);
      print('🔹 Fetch Units URL: $url');
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      // Make the GET request
      final response = await dio.get(
        url,
        options: Options(
          contentType: "application/json",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
            // Add any other headers if needed
          },
        ),
      );

      // Logging
      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      // Check response and parse
      if (response.statusCode == 200) {
        return FetchUnitResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during fetchUnits: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }
}
