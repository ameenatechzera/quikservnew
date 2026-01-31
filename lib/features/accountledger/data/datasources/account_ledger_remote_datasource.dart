import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class AccountLedgerRemoteDataSource {
  Future<FetchAccountLedgerResponseModel> fetchAccountLedgers();
  Future<MasterResponseModel> deleteAccountLedger(int ledgerId);
  Future<MasterResponseModel> saveAccountLedger(AccountLedgerParams params);
  Future<MasterResponseModel> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  );
}

class AccountLedgerRemoteDataSourceImpl
    implements AccountLedgerRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<FetchAccountLedgerResponseModel> fetchAccountLedgers() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getAccountLedgerPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Fetch Account Ledger URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: $token');

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
        return FetchAccountLedgerResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, s) {
      print('❌ Exception in fetchAccountLedgers: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> deleteAccountLedger(int ledgerId) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.deleteAccountLedgerPath(baseUrl, ledgerId);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Delete Account Ledger URL: $url');
      print('🔹 Ledger ID: $ledgerId');
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
      print('❌ Exception in deleteAccountLedger: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> saveAccountLedger(
    AccountLedgerParams params,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.saveAccountLedgerPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Save Account Ledger URL: $url');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');
      print('🔹 Request Body: ${params.toJson()}');

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      final response = await dio.post(
        url,
        data: params.toJson(),
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
      print('❌ Exception in saveAccountLedger: $e');
      print(s);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.updateAccountLedgerPath(
        baseUrl,
        ledgerId,
      ); // 🔥 update API
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      // debug prints
      print('🔹 Update Account Ledger URL: $url');
      print('🔹 Ledger ID: $ledgerId');
      print('🔹 DB Name: $dbName');
      print('🔹 Token exists: ${token.isNotEmpty}');
      print('🔹 Request Body: ${params.toJson()}');

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      final response = await dio.post(
        // ⚠️ change to POST if backend expects POST
        url,
        data: params.toJson(),
        options: Options(
          contentType: "application/json",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
          },
        ),
      );
      debugPrint(
        "🔵 UPDATE LEDGER URL: ${ApiConstants.updateAccountLedgerPath(baseUrl, ledgerId)}/$ledgerId",
      );
      debugPrint("🔵 UPDATE LEDGER BODY: ${params.toJson()}");

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
      print('❌ Exception in updateAccountLedger: $e');
      print(s);
      rethrow;
    }
  }
}
