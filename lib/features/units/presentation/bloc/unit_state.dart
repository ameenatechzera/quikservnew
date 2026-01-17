part of 'unit_cubit.dart';

sealed class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object> get props => [];
}

final class UnitInitial extends UnitState {}

class UnitLoading extends UnitState {}

class UnitLoaded extends UnitState {
  final FetchUnitResponseModel units;

  const UnitLoaded({required this.units});
}

class UnitError extends UnitState {
  final String error;

  const UnitError({required this.error});
}

// 🔹 States for saving a unit
class UnitSaveLoading extends UnitState {}

class UnitSaved extends UnitState {
  final MasterResponseModel response;
  const UnitSaved({required this.response});
}

class UnitSaveError extends UnitState {
  final String error;
  const UnitSaveError({required this.error});
}

/* ---------- DELETE ---------- */
class UnitDeleteLoading extends UnitState {}

class UnitDeleted extends UnitState {
  final MasterResponseModel response;

  const UnitDeleted({required this.response});
}

class UnitDeleteError extends UnitState {
  final String error;

  const UnitDeleteError({required this.error});
}

/// ================= EDIT =================
class UnitEditLoading extends UnitState {}

class UnitEdited extends UnitState {
  final MasterResponseModel response;

  const UnitEdited({required this.response});
}

class UnitEditError extends UnitState {
  final String error;

  const UnitEditError({required this.error});
}
