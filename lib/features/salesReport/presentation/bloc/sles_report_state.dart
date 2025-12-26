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

class SalesReportError extends SlesReportState {
  final String error;

  SalesReportError({required this.error});
}

class SalesDetailsError extends SlesReportState {
  final String error;

  SalesDetailsError({required this.error});
}
