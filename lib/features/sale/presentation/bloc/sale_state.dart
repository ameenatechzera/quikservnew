part of 'sale_cubit.dart';

sealed class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

final class SaleInitial extends SaleState {}

final class SlesDetailsFetchInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleSuccess extends SaleState {
  final SalesResponseEntity response;

  const SaleSuccess({required this.response});
}

class SaleError extends SaleState {
  final String error;

  const SaleError({required this.error});
}

// SearchBarState
class SearchBarState extends SaleState {
  final bool isVisible;

  const SearchBarState(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

//  MenuModeState
class MenuModeState extends SaleState {
  final bool isMenuMode;

  const MenuModeState(this.isMenuMode);

  @override
  List<Object> get props => [isMenuMode];
}

// SearchQueryState
class SearchQueryState extends SaleState {
  final String query;

  const SearchQueryState(this.query);

  @override
  List<Object> get props => [query];
}

// SelectedCategoryState
class SelectedCategoryState extends SaleState {
  final int id;
  final String name;

  const SelectedCategoryState({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class SalesReportFetchError extends SaleState {
  final String error;

  const SalesReportFetchError({required this.error});
}

class SalesDetailsFetchSuccess extends SaleState {
  final SalesDetailsByMasterIdResult response;

  const SalesDetailsFetchSuccess({required this.response});
}
