part of 'sales_count_cubit.dart';

@immutable
sealed class SalesCountState {}

final class SalesCountInitial extends SalesCountState {}
final class FetchSales_CountGraphLoading extends SalesCountState {}
final class FetchCustom_SalesGraphLoading extends SalesCountState {}

class FetchSales_CountGraphError extends SalesCountState {
  final String message;
  FetchSales_CountGraphError(this.message);

  @override
  List<Object> get props => [message];
}
class FetchSales_CountGraphSuccess extends SalesCountState {
  final MonthlyGraphReportResult graphResult;
  FetchSales_CountGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}
class FetchCustom_SalesGraphError extends SalesCountState {
  final String message;
  FetchCustom_SalesGraphError(this.message);

  @override
  List<Object> get props => [message];
}
class FetchCustom_SalesGraphSuccess extends SalesCountState {
  final MonthlyGraphReportResult graphResult;
  FetchCustom_SalesGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}
