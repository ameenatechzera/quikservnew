part of 'vat_cubit.dart';

sealed class VatState extends Equatable {
  const VatState();

  @override
  List<Object> get props => [];
}

final class VatInitial extends VatState {}

final class VatLoading extends VatState {}

final class VatLoaded extends VatState {
  final FetchVatResponseModel vat;

  const VatLoaded({required this.vat});

  @override
  List<Object> get props => [vat];
}

final class VatError extends VatState {
  final String error;

  const VatError({required this.error});

  @override
  List<Object> get props => [error];
}
