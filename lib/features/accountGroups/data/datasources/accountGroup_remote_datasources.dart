import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/accountGroups/data/models/accountGroupModel.dart';
import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/delete_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/save_accountgroup_request.dart';
import 'package:quikservnew/features/accountGroups/domain/parameters/update_accountgroup_request.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class AccountGroupsRemoteDataSource {
  Future<AccountGroupResponse> fetchAccountGroups();
  Future<MasterResponseModel> saveAccountGroups(SaveAccountGroupRequest request);
  Future<MasterResponseModel> deleteAccountGroups(DeleteAccountGroupRequest request);
  Future<MasterResponseModel> updateAccountGroups(UpdateAccountGroupRequest request);


}
class AccountGroupsRemoteDataSourceImpl implements AccountGroupsRemoteDataSource {
  Dio dio = Dio();
  @override
  Future<AccountGroupResponse> fetchAccountGroups() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.getAccountGroupsPath(baseUrl);
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
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        return AccountGroupModel.fromJson(response.data);
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
  Future<MasterResponseModel> saveAccountGroups(SaveAccountGroupRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.getSaveAccountGroupsPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      final response = await dio.post(
        url,
        data: request,
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
      if (response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
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
  Future<MasterResponseModel> deleteAccountGroups(DeleteAccountGroupRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.getDeleteAccountGroupsPath(baseUrl,request.accGroupId);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      print('url $url');
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
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
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
  Future<MasterResponseModel> updateAccountGroups(UpdateAccountGroupRequest request) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty)
        throw Exception("Base URL not set");

      final url = ApiConstants.getUpdateAccountGroupsPath(baseUrl,request.acc_groupId);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      print('url $url');
      if (token.isEmpty) throw Exception("Token missing! Please login again.");

      final response = await dio.post(
        url,
        data: request,
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
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
}