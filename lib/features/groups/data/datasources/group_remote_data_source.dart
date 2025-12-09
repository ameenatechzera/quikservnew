// groups_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/groups/data/models/fetch_group_model.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class GroupsRemoteDataSource {
  Future<FetchGroupResponseModel> fetchGroups();
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
}
