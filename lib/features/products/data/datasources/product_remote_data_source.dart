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
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      if (token.isEmpty) throw Exception("Token missing! Please login again.");
      final url = ApiConstants.getProductsPath(baseUrl);
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
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }
      final url = ApiConstants.saveProductPath(baseUrl);
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
      throw Exception("Error saving product: $e");
    }
  }

  @override
  Future<MasterResponseModel> deleteProductFromServer(int productCode) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.deleteProductPath(baseUrl, productCode);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
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
      final url = ApiConstants.updateProductPath(baseUrl, productCode);
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
      throw Exception("Error updating product: $e");
    }
  }
}
