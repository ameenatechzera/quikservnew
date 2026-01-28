import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class ProductsRemoteDataSource {
  Future<FetchProductResponseModel> fetchProducts();
  Future<MasterResponseModel> saveProduct(ProductSaveRequest request);
  Future<MasterResponseModel> deleteProductFromServer(int productCode);
  Future<MasterResponseModel> updateProduct(
    int productCode,
    ProductSaveRequest request,
  );
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<FetchProductResponseModel> fetchProducts() async {
    print('called');
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      print(dbName);
      print(token);
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      final url = ApiConstants.getProductsPath(baseUrl);
      print(url);
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
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        return FetchProductResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  @override
  Future<MasterResponseModel> saveProduct(ProductSaveRequest request) async {
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
      print('Saving Product Data: ${request.toJson()}');
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

  @override
  Future<MasterResponseModel> deleteProductFromServer(int productCode) async {
    try {
      // 🔹 Get base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      // 🔹 Build API URL (productId appended)
      final url = ApiConstants.deleteProductPath(baseUrl, productCode);
      print('🔹 Delete Product URL: $url');

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
      print('❌ Exception during deleteProduct: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> updateProduct(
    int productCode,
    ProductSaveRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      // 🔹 Update product endpoint
      final url = ApiConstants.updateProductPath(baseUrl, productCode);
      // 🔹 Print the data being sent
      print('Updating Product Data: ${request.toJson()}');
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

      print('Update Product Status: ${response.statusCode}');
      print('Update Product Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      throw Exception("Error updating product: $e");
    }
  }
}
