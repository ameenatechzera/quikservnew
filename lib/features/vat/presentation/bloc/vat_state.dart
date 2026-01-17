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

/// 🔹 Add VAT
class VatAddLoading extends VatState {}

class VatAdded extends VatState {
  final MasterResponseModel response;

  const VatAdded({required this.response});
}

class VatAddError extends VatState {
  final String error;

  const VatAddError({required this.error});
}

/// ================= DELETE VAT STATES =================
class VatDeleteLoading extends VatState {}

class VatDeleted extends VatState {
  final MasterResponseModel response;

  const VatDeleted({required this.response});
}

class VatDeleteError extends VatState {
  final String error;

  const VatDeleteError({required this.error});
}

class VatEditLoading extends VatState {}

class VatEdited extends VatState {
  final MasterResponseModel response;
  const VatEdited({required this.response});
}

class VatEditError extends VatState {
  final String error;
  const VatEditError({required this.error});
}
