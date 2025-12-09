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
