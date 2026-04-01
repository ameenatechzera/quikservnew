import 'package:dio/dio.dart';
import 'package:quikservnew/core/errors/error_message_model.dart';
import 'package:quikservnew/core/errors/exceptions.dart';
import 'package:quikservnew/core/network/api_endpoints.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/data/models/monthly_graph_model.dart';
import 'package:quikservnew/features/settings/data/models/print_save_result_model.dart';
import 'package:quikservnew/features/settings/data/models/sales_count_graph_model.dart';
import 'package:quikservnew/features/settings/data/models/weekly_graph_model.dart';
import 'package:quikservnew/features/settings/domain/entities/common_result.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_details_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_update_result.dart';
import 'package:quikservnew/features/settings/domain/entities/weekly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/sales_tokenupdate_request.dart'
    show UpdateSalesTokenRequest;
import 'package:quikservnew/features/settings/domain/parameters/save_printersettings_request.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

abstract class SettingsRemoteDataSource {
  Future<FetchSettingsResponseModel> fetchSettings();
  Future<CommonResult> refreshSalesToken();
  Future<TokenDetailsResult> fetchCurrentSalesToken();
  Future<TokenUpdateResult> updateSalesTokenToServer(
    UpdateSalesTokenRequest updateSalesTokenRequest,
  );

  Future<MasterResponseModel> saveAccountSettings(
    AccountSettingsParams accountSettingsParams,
  );
  Future<MonthlyGraphReportResult> fetchMonthlyGraphReport(
    BarGraphRequest request,
  );
  Future<WeeklyGraphReportResult> fetchWeeklyGraphReport(
    BarGraphRequest request,
  );
  Future<MonthlyGraphReportResult> fetchSalesCountGraph(
    BarGraphRequest request,
  );
  Future<MonthlyGraphReportResult> fetchCustomSalesGraph(
    CustomSalesGraphRequest request,
  );
  Future<PrinterSettingsResultModel> savePrinterSettings(
    SavePrinterSettingsRequest savePrinterSettings,
  );
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<FetchSettingsResponseModel> fetchSettings() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.getSettingsPath(baseUrl);
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
      if (response.statusCode == 200) {
        return FetchSettingsResponseModel.fromJson(response.data);
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
  Future<CommonResult> refreshSalesToken() async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.resetSalesTokenPath(baseUrl);
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
      if (response.statusCode == 200) {
        return CommonResult.fromJson(response.data);
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
  Future<TokenDetailsResult> fetchCurrentSalesToken() async {
    final dbName = await SharedPreferenceHelper().getDatabaseName();
    final token = await SharedPreferenceHelper().getToken() ?? "";
    final baseUrl = await SharedPreferenceHelper().getBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception("Base URL not set");
    }
    String refreshTokenUrl = ApiConstants.fetchSalesTokenPath(baseUrl);
    try {
      final response = await dio.get(
        refreshTokenUrl,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Empty response from server');
        }
        return TokenDetailsResult.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      throw Exception("Failed   refreshTokenUrl ");
    }
  }

  @override
  Future<TokenUpdateResult> updateSalesTokenToServer(
    UpdateSalesTokenRequest updateSalesTokenRequest,
  ) async {
    final dbName = await SharedPreferenceHelper().getDatabaseName();
    final token = await SharedPreferenceHelper().getToken() ?? "";
    final baseUrl = await SharedPreferenceHelper().getBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception("Base URL not set");
    }
    String refreshTokenUrl = ApiConstants.updateSalesTokenPath(baseUrl);
    try {
      final response = await dio.post(
        refreshTokenUrl,
        data: updateSalesTokenRequest.toJson(),
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "X-Database-Name": dbName,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Empty response from server');
        }
        return TokenUpdateResult.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      throw Exception("Failed   refreshTokenUrl ");
    }
  }

  @override
  Future<MasterResponseModel> saveAccountSettings(
    AccountSettingsParams accountSettingsParams,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.saveAccountSettingsPath(baseUrl, 1);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");
      final response = await dio.post(
        url,
        data: accountSettingsParams.toJson(),
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
  Future<MonthlyGraphReportResult> fetchMonthlyGraphReport(
    BarGraphRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.fetchSalesGraphReportPath(baseUrl);
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
      if (response.statusCode == 200) {
        return MonthlyGraphModel.fromJson(response.data);
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
  Future<WeeklyGraphReportResult> fetchWeeklyGraphReport(
    BarGraphRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.fetchSalesGraphReportPath(baseUrl);
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
      if (response.statusCode == 200) {
        return WeeklyGraphReportModel.fromJson(response.data);
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
  Future<MonthlyGraphReportResult> fetchSalesCountGraph(
    BarGraphRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      final url = ApiConstants.fetchSalesCountGraphReportPath(baseUrl);
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
      if (response.statusCode == 200) {
        return SalesCountGraphModel.fromJson(response.data);
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
  Future<MonthlyGraphReportResult> fetchCustomSalesGraph(
    CustomSalesGraphRequest request,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      var url = ApiConstants.fetchSalesGraphReportPath(baseUrl);
      if (request.salesType == 'count') {
        url = ApiConstants.fetchSalesCountGraphReportPath(baseUrl);
      }
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
      if (response.statusCode == 200) {
        return MonthlyGraphModel.fromJson(response.data);
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
  Future<PrinterSettingsResultModel> savePrinterSettings(
    SavePrinterSettingsRequest savePrinterSettings,
  ) async {
    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }
      var url = ApiConstants.fetchSavePrinterSettingsPath(baseUrl);
      final dbName = await SharedPreferenceHelper().getDatabaseName();
      final token = await SharedPreferenceHelper().getToken() ?? "";
      if (token.isEmpty) throw Exception("Token missing! Please login again.");
      final response = await dio.post(
        url,
        data: savePrinterSettings.toJson(),
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
        return PrinterSettingsResultModel.fromJson(response.data);
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
