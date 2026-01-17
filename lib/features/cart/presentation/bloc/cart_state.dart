part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}
final class SlesDetailsFromCartInitial extends CartState {}

class SalesReportFromCartError extends CartState {
  final String error;

  SalesReportFromCartError({required this.error});
}

class SalesDetailsFromCartSuccess extends CartState {
  final SalesDetailsByMasterIdResult response;

  SalesDetailsFromCartSuccess({required this.response});
}