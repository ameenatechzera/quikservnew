import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyclosingreport_request.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/dayclose_report_cubit.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/item_bloc/item_cubit.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_screen.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class DailyclosingreportHelper {
  /// 🔹 API / DB CALL
  Future<void> fetchSalesReport({
    required BuildContext context,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final sharedPrefHelper = SharedPreferenceHelper();
    st_branchId = await sharedPrefHelper.getBranchId();

    // context.read<ItemWiseReportCubit>().fetchItemWiseReport(
    //   ItemWiseReportRequest(
    //     FromDate: formatter.format(fromDate),
    //     ToDate: formatter.format(toDate),
    //     branchId: st_branchId,
    //   ),
    // );

    context.read<ItemCubit>().fetchItemWiseReports(
      ItemWiseReportRequest(
        fromDate: formatter.format(fromDate),
        toDate: formatter.format(toDate),
        branchId: st_branchId,
      ),
    );

    context.read<DaycloseReportCubit>().fetchDayCloseReport(
      DailyCloseReportRequest(
        FromDate: formatter.format(fromDate),
        ToDate: formatter.format(toDate),
        branchId: st_branchId,
      ),
    );
  }
}
