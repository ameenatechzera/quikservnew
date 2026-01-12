part of 'sles_report_cubit.dart';

@immutable
sealed class SlesReportState {}

final class SlesReportInitial extends SlesReportState {}

final class SlesDetailsInitial extends SlesReportState {}

class SalesReportSuccess extends SlesReportState {
  final SalesReportResult response;

  SalesReportSuccess({required this.response});
}

class SalesDetailsSuccess extends SlesReportState {
  final SalesDetailsByMasterIdResult response;

  SalesDetailsSuccess({required this.response});
}

class SaleFinishSuccess extends SlesReportState {
  final String response;

  SaleFinishSuccess({required this.response});
}

class SalesReportError extends SlesReportState {
  final String error;

  SalesReportError({required this.error});
}

class SalesDetailsError extends SlesReportState {
  final String error;

  SalesDetailsError({required this.error});
}

// New states for MasterByDate
class SalesReportMasterByDateInitial extends SlesReportState {}

class SalesReportMasterByDateSuccess extends SlesReportState {
  final SalesReportResult response;
  final int totalSalesCount;
  final double totalSalesAmount;
  final double cashBalance;
  SalesReportMasterByDateSuccess({
    required this.response,
    required this.totalSalesCount,
    required this.totalSalesAmount,
    required this.cashBalance,
  });
}

class SalesReportMasterByDateError extends SlesReportState {
  final String error;
  SalesReportMasterByDateError({required this.error});
}
