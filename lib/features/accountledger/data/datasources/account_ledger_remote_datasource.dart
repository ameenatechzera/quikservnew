import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_accountledger_model.dart';
import 'package:quikservnew/features/accountledger/data/models/fetch_bankaccountledger_model.dart';
import 'package:quikservnew/features/accountledger/domain/entities/accLedgerResponse.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/fetch_backaccountledger_parameter.dart';
import 'package:quikservnew/features/accountledger/domain/parameters/save_account_ledger_parameter.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class AccountLedgerRemoteDataSource {
  Future<FetchAccountLedgerResponseModel> fetchAccountLedgers();
  Future<MasterResponseModel> deleteAccountLedger(int ledgerId);
  Future<AccLedgerResponseModel> saveAccountLedger(AccountLedgerParams params);
  Future<MasterResponseModel> updateAccountLedger(
    int ledgerId,
    AccountLedgerParams params,
  );
  Future<FetchBankAccountLedgerResponseModel> fetchBankAccountLedger(
    FetchBankAccountLedgerParams params,
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

      if (response.statusCode == 200) {
        return FetchAccountLedgerResponseModel.fromJson(response.data);
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
  Future<MasterResponseModel> deleteAccountLedger(int ledgerId) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.deleteAccountLedgerPath(baseUrl, ledgerId);
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
      if (response.statusCode == 200) {
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
  Future<AccLedgerResponseModel> saveAccountLedger(
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AccLedgerResponseModel.fromJson(response.data);
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

      if (response.statusCode == 200) {
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
  Future<FetchBankAccountLedgerResponseModel> fetchBankAccountLedger(
    FetchBankAccountLedgerParams params,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getBankAccountLedgerPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";

      if (token.isEmpty) {
        throw Exception("Token missing! Please login again.");
      }

      final response = await dio.post(
        url,
        data: params,
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
        return FetchBankAccountLedgerResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
