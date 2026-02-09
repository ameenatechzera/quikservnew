import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/authentication/domain/entities/login_entity.dart';
import 'package:quikservnew/features/authentication/domain/entities/register_server_response_entity.dart';
import 'package:quikservnew/features/authentication/domain/parameters/changepassword_parameter.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseResult> registerServer(
    RegisterServerRequest registerServerParams,
  );
  Future<LoginResponseResult> loginServer(LoginRequest loginRequest);
  Future<MasterResponseModel> changePassword(ChangePasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<RegisterResponseResult> registerServer(
    RegisterServerRequest registerServerParams,
  ) async {
    // Load base URL safely
    final baseUrl = await SharedPreferenceHelper().getBaseUrl();

    if (baseUrl == null || baseUrl.isEmpty) {}

    final url = ApiConstants.getRegisterServerPath(baseUrl!);
    print('Register URL: $url');
    print('Request Body: ${registerServerParams.toJson()}');

    print(registerServerParams);
    final response = await dio.post(
      ApiConstants.getRegisterServerPath(baseUrl),
      options: Options(contentType: "application/json"),
      data: registerServerParams.toJson(),
    );
    print(response.data);
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
    if (response.statusCode == 200) {
      return RegisterResponseResult.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<LoginResponseResult> loginServer(LoginRequest params) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final url = ApiConstants.getLoginPath(baseUrl);
      print('🔹 Login URL: $url');
      print('🔹 Request Body: ${params.toJson()}');
      print('🔹 dbName: $dbName');

      final response = await dio.post(
        url,
        data: params.toJson(),
        options: Options(
          contentType: "application/json",
          headers: {"Accept": "application/json", "X-Database-Name": dbName},
        ),
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return LoginResponseResult.fromJson(response.data["data"]);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during loginServer: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final url = ApiConstants.getChangePasswordPath(baseUrl);

      print('🔹 Change Password URL: $url');
      print('🔹 Request Body: ${request.toJson()}');

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          contentType: "application/json",
          headers: {"Accept": "application/json", "X-Database-Name": dbName},
        ),
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception during changePassword: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }
}
