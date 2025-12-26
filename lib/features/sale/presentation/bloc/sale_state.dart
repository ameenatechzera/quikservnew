part of 'sale_cubit.dart';

sealed class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

final class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleSuccess extends SaleState {
  final SalesResponseEntity response;

  SaleSuccess({required this.response});
}

class SaleError extends SaleState {
  final String error;

  SaleError({required this.error});
}

class SaleTabChanged extends SaleState {
  final int selectedIndex;

  const SaleTabChanged(this.selectedIndex);
}
