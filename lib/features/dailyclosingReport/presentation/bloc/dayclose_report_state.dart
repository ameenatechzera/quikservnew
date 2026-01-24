part of 'dayclose_report_cubit.dart';

@immutable
sealed class DaycloseReportState {}

final class DaycloseReportInitial extends DaycloseReportState {}

final class ItemWiseDetailsInitial extends DaycloseReportState {}

class DayCloseReportFailure extends DaycloseReportState {
  final String error;

  DayCloseReportFailure(this.error);
}
class DayCloseReportLoaded extends DaycloseReportState {
  final DailyClosingReportResponse dayCloseReport;

  DayCloseReportLoaded({required this.dayCloseReport});

}
class ItemDetailsFailure extends DaycloseReportState {
  final String error;

  ItemDetailsFailure(this.error);
}
class ItemDetailsLoaded extends DaycloseReportState {
  final List<SummaryReport> itemWisReport;

  ItemDetailsLoaded({required this.itemWisReport});

}