import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class ProductsRemoteDataSource {
  Future<FetchProductResponseModel> fetchProducts();
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
}
