part of 'sale_cubit.dart';

sealed class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

final class SaleInitial extends SaleState {}

final class SlesDetailsFetchInitial extends SaleState {}

final class CategoryReloadLoading extends SaleState{}

final class ProductReloadLoading extends SaleState{}

final class SettingsReloadLoading extends SaleState{}

final class LoyaltyDetailsBySearchInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleSuccess extends SaleState {
  final SalesResponseEntity response;

  const SaleSuccess({required this.response});
}
class SettingsReloadError extends SaleState {
  final String error;

  const SettingsReloadError({required this.error});
}
final class CategoryReloadError extends SaleState {
  final String error;

  const CategoryReloadError({required this.error});
}
class SettingsReloadLoaded extends SaleState {
  final FetchSettingsResponseModel settings;

  const SettingsReloadLoaded({required this.settings});
}

class ProductReloadSuccess extends SaleState {
  final FetchProductResponseModel products;

  const ProductReloadSuccess(this.products);
}
final class CategoryReloadLoaded extends SaleState {
  final FetchCategoryResponseModel categories;

  const CategoryReloadLoaded({required this.categories});
}
class SaleError extends SaleState {
  final String error;

  const SaleError({required this.error});
}
class ProductReloadFailure extends SaleState {
  final String error;

  const ProductReloadFailure(this.error);
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

class LoyaltyBySearchError extends SaleState {
  final String error;

  const LoyaltyBySearchError({required this.error});
}

class SalesDetailsFetchSuccess extends SaleState {
  final SalesDetailsByMasterIdResult response;

  const SalesDetailsFetchSuccess({required this.response});
}

class LoyaltyBySearchFetchSuccess extends SaleState {
  final LoyaltySearchResult response;

  const LoyaltyBySearchFetchSuccess({required this.response});
}

// class FetchLoyaltyCustomersLoading extends SaleState {
//   const FetchLoyaltyCustomersLoading();
// }

// // Success State
// class FetchLoyaltyCustomersSuccess extends SaleState {
//   final LoyaltyCustomerListResult loyaltyCustomers;

//   const FetchLoyaltyCustomersSuccess(this.loyaltyCustomers);
// }

// // Error States
// class FetchLoyaltyCardError extends SaleState {
//   final String error;

//   const FetchLoyaltyCardError(this.error);
// }

// class FetchLoyaltyCustomersError extends SaleState {
//   final String error;

//   const FetchLoyaltyCustomersError(this.error);
// }
