import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/entities/save_category_entity.dart';
import 'package:quikservnew/features/category/domain/parameters/edit_category_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class CategoriesRemoteDataSource {
  Future<FetchCategoryResponseModel> fetchCategories();
  Future<MasterResponseModel> saveCategory(SaveCategoryRequestModel request);
  Future<MasterResponseModel> deleteCategory(int categoryId);
  Future<MasterResponseModel> editCategory(
    int categoryId,
    EditCategoryRequestModel request,
  );
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<FetchCategoryResponseModel> fetchCategories() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getCategoriesPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints (remove in production)
      print('🔹 Fetch Categories URL: $url');
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

      if (response.statusCode == 200) {
        return FetchCategoryResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in fetchCategories: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> saveCategory(
    SaveCategoryRequestModel request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.saveCategoryPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Save Category URL: $url');
      print('🔹 Request Body: ${request.toJson()}');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

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
      print('❌ Exception in saveCategory: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> deleteCategory(int categoryId) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.deleteCategoryPath(baseUrl, categoryId);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Delete Category URL: $url');
      print('🔹 Category ID: $categoryId');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

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

      if (response.statusCode == 200) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in deleteCategory: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> editCategory(
    int categoryId,
    EditCategoryRequestModel request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.editCategoryPath(baseUrl, categoryId);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Edit Category URL: $url');
      print('🔹 Category ID: $categoryId');
      print('🔹 Request Body: ${request.toJson()}');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');

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
      print('❌ Exception in editCategory: $e');
      print(s);
      rethrow;
    }
  }
}
