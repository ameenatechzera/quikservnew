import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/common_result.dart';
import 'package:quikservnew/features/settings/domain/entities/monthly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/entities/printer_save_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_details_result.dart';
import 'package:quikservnew/features/settings/domain/entities/token_update_result.dart';
import 'package:quikservnew/features/settings/domain/entities/weekly_graph_report_result.dart';
import 'package:quikservnew/features/settings/domain/parameters/account_settings_parameter.dart';
import 'package:quikservnew/features/settings/domain/parameters/bargraph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/custom_sales_graph_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/sales_tokenupdate_request.dart';
import 'package:quikservnew/features/settings/domain/parameters/save_printersettings_request.dart';

abstract class SettingsRepository {
  ResultFuture<FetchSettingsResponseModel> fetchSettings();
  ResultFuture<CommonResult> refreshSalesToken();
  ResultFuture<TokenDetailsResult> fetchCurrentSalesTokenDetails();
  ResultFuture<TokenUpdateResult> updateSalesTokenToServer(
    UpdateSalesTokenRequest updateSalesTokenRequest,
  );
  ResultFuture<MonthlyGraphReportResult> fetchMonthlyGraphReport(
    BarGraphRequest request,
  );
  ResultFuture<WeeklyGraphReportResult> fetchWeeklyGraphReport(
    BarGraphRequest request,
  );

  ResultFuture<MasterResponseModel> saveAccountSettings(
    AccountSettingsParams params,
  );

  ResultFuture<MonthlyGraphReportResult> fetchSalesCountReport(
    BarGraphRequest params,
  );

  ResultFuture<MonthlyGraphReportResult> fetchCustomSalesGraph(
    CustomSalesGraphRequest params,
  );

  ResultFuture<PrinterSettingsSaveResult> savePrinterSettingsToServer(
    SavePrinterSettingsRequest savePrinterSettingsRequest,
  );
}
