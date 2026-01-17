import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/features/groups/domain/parameters/add_productgroup_parameter.dart';
import 'package:quikservnew/features/groups/domain/parameters/update_productgrooup_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class GroupsRemoteDataSource {
  Future<FetchGroupResponseModel> fetchGroups();
  Future<MasterResponseModel> addProductGroup(
    AddProductGroupRequestModel request,
  );
  Future<MasterResponseModel> deleteProductGroup(int groupId);
  Future<MasterResponseModel> editProductGroup(
    int groupId,
    EditProductGroupRequestModel request,
  );
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<FetchGroupResponseModel> fetchGroups() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.getGroupsPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
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
      print('ongoingdone');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        return FetchGroupResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      print("❌ Exception in fetchGroups: $e");
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> addProductGroup(
    AddProductGroupRequestModel request,
  ) async {
    try {
      // 🔹 Get base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // 🔹 Build API URL
      final url = ApiConstants.saveProductGroupPath(
        baseUrl,
      ); // create this endpoint in ApiConstants
      print('🔹 Add Product Group URL: $url');

      // 🔹 Get headers
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      // 🔹 POST request
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
      print('❌ Exception during addProductGroup: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> deleteProductGroup(int groupId) async {
    try {
      // 🔹 Get base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // 🔹 Build API URL
      final url = ApiConstants.deleteProductGroupPath(baseUrl, groupId);
      print('🔹 Delete Product Group URL: $url');

      // 🔹 Get headers
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
      print('❌ Exception during deleteProductGroup: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> editProductGroup(
    int groupId,
    EditProductGroupRequestModel request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.editProductGroupPath(baseUrl, groupId);
      // Add endpoint in ApiConstants
      print('🔹 Edit Product Group URL: $url');

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

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during editProductGroup: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }
}
