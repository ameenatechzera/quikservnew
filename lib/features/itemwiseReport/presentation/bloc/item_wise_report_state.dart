part of 'item_wise_report_cubit.dart';

@immutable
sealed class ItemWiseReportState {}

final class ItemWiseReportInitial extends ItemWiseReportState {}

class ItemSaleReportFailure extends ItemWiseReportState {
  final String error;

  ItemSaleReportFailure(this.error);
}
class ItemSaleReportLoaded extends ItemWiseReportState {
  final List<SummaryReport> itemWisReport;

  ItemSaleReportLoaded({required this.itemWisReport});

}