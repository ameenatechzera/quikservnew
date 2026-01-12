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

// class SaleTabChanged extends SaleState {
//   final int selectedIndex;

//   const SaleTabChanged(this.selectedIndex);
// }

// ✅ NEW: Add SearchBarState
class SearchBarState extends SaleState {
  final bool isVisible;

  const SearchBarState(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

// ✅ NEW: Add MenuModeState
class MenuModeState extends SaleState {
  final bool isMenuMode;

  const MenuModeState(this.isMenuMode);

  @override
  List<Object> get props => [isMenuMode];
}

// ✅ NEW: Add SearchQueryState
class SearchQueryState extends SaleState {
  final String query;

  const SearchQueryState(this.query);

  @override
  List<Object> get props => [query];
}

// ✅ NEW: SelectedCategoryState
class SelectedCategoryState extends SaleState {
  final int id;
  final String name;

  const SelectedCategoryState({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
