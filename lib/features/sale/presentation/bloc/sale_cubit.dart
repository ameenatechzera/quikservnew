import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/category/data/models/fetch_category_model.dart';
import 'package:quikservnew/features/category/domain/repositories/category_local_repository.dart';
import 'package:quikservnew/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';
import 'package:quikservnew/features/sale/domain/parameters/loyalty_search_request.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';
import 'package:quikservnew/features/sale/domain/usecases/fetch_loyaltydetailsby_search_usecase.dart';
import 'package:quikservnew/features/sale/domain/usecases/save_sale_toserver_usecase.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesdetails_bymasterid_usecase.dart';
import 'package:quikservnew/features/settings/data/models/fetch_settings_model.dart';
import 'package:quikservnew/features/settings/domain/entities/loyalty_customer_entity.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_loyalty_customers_usecase.dart';
import 'package:quikservnew/features/settings/domain/usecases/fetch_settings_usecase.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  final SaveSaleUseCase _saveSaleUseCase;
  final SalesDetailsByMasterIdUseCase _salesDetailsByMasterIdUseCase;
  final FetchLoyaltyDetailsBySearchUseCase _fetchLoyaltyDetailsBySearchUseCase;
  final ProductLocalRepository _productLocalRepository;
  final FetchCategoriesUseCase _fetchCategoriesUseCase;
  final FetchProductsUseCase fetchProductsUseCase;
  final FetchSettingsUseCase _fetchSettingsUseCase;
  final CategoryLocalRepository _categoryLocalRepository;
  //final FetchLoyaltyCustomersUseCase _fetchLoyaltyCustomersUseCase;

  //use this while reload


  bool _isSearchBarVisible = false;
  bool _isMenuMode = false;
  String _searchQuery = '';
  int _selectedCategoryId = 0;
  String _selectedCategoryName = 'All';
  double _editedPrice = 0;
  bool _isPriceEditing = false;
  double get editedPrice => _editedPrice;
  bool get isPriceEditing => _isPriceEditing;
  SaleCubit({
    required FetchCategoriesUseCase fetchCategoriesUseCase,
    required this.fetchProductsUseCase,
    required CategoryLocalRepository categoryLocalRepository,
    required FetchSettingsUseCase fetchSettingsUseCase,
    required SaveSaleUseCase saveSaleUseCase,
    required SalesRepository salesRepository,
    required SalesDetailsByMasterIdUseCase salesDetailsByMasterIdUseCase,
    required ProductLocalRepository productLocalRepository,
    required FetchLoyaltyDetailsBySearchUseCase
    fetchLoyaltyDetailsBySearchUseCase,
    // required FetchLoyaltyCustomersUseCase fetchLoyaltyCustomersUseCase,
  }) : _saveSaleUseCase = saveSaleUseCase,
        _productLocalRepository = productLocalRepository,
       _salesDetailsByMasterIdUseCase = salesDetailsByMasterIdUseCase,
       _fetchLoyaltyDetailsBySearchUseCase = fetchLoyaltyDetailsBySearchUseCase,
  _fetchSettingsUseCase = fetchSettingsUseCase,

  _fetchCategoriesUseCase = fetchCategoriesUseCase,
        _categoryLocalRepository = categoryLocalRepository,

       //_fetchLoyaltyCustomersUseCase = fetchLoyaltyCustomersUseCase,
       super(SaleInitial());
  void showSearchBar() {
    _isSearchBarVisible = true;
    emit(SearchBarState(_isSearchBarVisible));
  }

  void hideSearchBar() {
    _isSearchBarVisible = false;
    emit(SearchBarState(_isSearchBarVisible));
  }

  void toggleSearchBar() {
    _isSearchBarVisible = !_isSearchBarVisible;
    emit(SearchBarState(_isSearchBarVisible));
  }

  bool get isSearchBarVisible => _isSearchBarVisible;
  void enableMenuMode() {
    _isMenuMode = true;
    emit(MenuModeState(_isMenuMode));
  }

  void disableMenuMode() {
    _isMenuMode = false;
    emit(MenuModeState(_isMenuMode));
  }

  void toggleMenuMode() {
    _isMenuMode = !_isMenuMode;
    emit(MenuModeState(_isMenuMode));
  }

  bool get isMenuMode => _isMenuMode;
  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    emit(SearchQueryState(_searchQuery));
  }

  void clearSearchQuery() {
    _searchQuery = '';
    emit(SearchQueryState(_searchQuery));
  }

  String get searchQuery => _searchQuery;
  // =================== ✅ Category Selection ===================
  // ✅ Category methods
  void selectCategory(int id, String name) {
    _selectedCategoryId = id;
    _selectedCategoryName = name;
    emit(
      SelectedCategoryState(
        id: _selectedCategoryId,
        name: _selectedCategoryName,
      ),
    );
  }

  void resetCategory() {
    _selectedCategoryId = 0;
    _selectedCategoryName = 'All';
    emit(const SelectedCategoryState(id: 0, name: 'All'));
  }

  int get selectedCategoryId => _selectedCategoryId;
  String get selectedCategoryName => _selectedCategoryName;
  // --------------------- API Save Sale ---------------------
  Future<void> saveSale(SaveSaleRequest request) async {
    print('SaveSaleRequest ${request.toJson()}');
    emit(SaleLoading());

    try {
      final response = await _saveSaleUseCase(request);

      response.fold(
        (failure) => emit(SaleError(error: failure.message)),
        (saleResponse) => emit(SaleSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SaleError(error: e.toString()));
    }
  }
  //Fetch Products while reload
  Future<void> fetchProductsReload() async {
    print('FetchProducts');
    emit(ProductReloadLoading());
    final response = await fetchProductsUseCase();
    response.fold(
          (failure) {
        emit(ProductReloadFailure(failure.message));
      },
          (productResponse) async {
        final productsList = productResponse.productDetails ?? [];
        try {
          await _productLocalRepository.saveProducts(productsList);
        } catch (e) {
          emit(ProductReloadFailure(e.toString()));
        }

        emit(ProductReloadSuccess(productResponse));
      },
    );
  }
  //Fetch Settings while reload
  Future<void> fetchSettingsReload() async {
    emit(SettingsReloadLoading());

    final response = await _fetchSettingsUseCase();

    response.fold(
          (failure) => emit(SettingsReloadError(error: failure.message)),
          (response) => emit(SettingsReloadLoaded(settings: response)),
    );
  }
  // --------------------- API Fetch ---------------------
  Future<void> fetchCategoriesReload() async {
    emit(CategoryReloadLoading());

    final response = await _fetchCategoriesUseCase();

    response.fold((failure) => emit(CategoryReloadError(error: failure.message)), (
        categoryResponse,
        ) async {
      final categoriesList = categoryResponse.categories ?? [];
      await _categoryLocalRepository.saveCategories(categoriesList);
      emit(CategoryReloadLoaded(categories: categoryResponse));
    });
  }
  // --------------------- API Fetch SalesDetails By MasterId ---------------------
  Future<void> fetchSalesDetailsByMasterId(
    FetchSalesDetailsRequest request,
  ) async {
    print('FetchSalesDetailsRequest ${request.toJson()}');
    emit(SlesDetailsFetchInitial());
    try {
      final response = await _salesDetailsByMasterIdUseCase(request);

      response.fold(
        (failure) => emit(SalesReportFetchError(error: failure.message)),
        (saleResponse) =>
            emit(SalesDetailsFetchSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(SalesReportFetchError(error: e.toString()));
    }
  }

  // --------------------- API  fetchLoyaltyDetailsBySearch  ---------------------
  Future<void> fetchLoyaltyDetailsBySearch(LoyaltySearchRequest request) async {
    print('FetchSalesDetailsBySearchRequest ${request.toJson()}');
    emit(LoyaltyDetailsBySearchInitial());
    try {
      final response = await _fetchLoyaltyDetailsBySearchUseCase(request);

      response.fold(
        (failure) => emit(LoyaltyBySearchError(error: failure.message)),
        (saleResponse) =>
            emit(LoyaltyBySearchFetchSuccess(response: saleResponse)),
      );
    } catch (e) {
      emit(LoyaltyBySearchError(error: e.toString()));
    }
  }

  // Future<void> fetchLoyaltyCustomersFromServer() async {
  //   emit(FetchLoyaltyCustomersLoading());
  //   try {
  //     final response = await _fetchLoyaltyCustomersUseCase();
  //     response.fold(
  //       (failure) async {
  //         emit(FetchLoyaltyCardError(failure.message));
  //       },
  //       (success) {
  //         emit(FetchLoyaltyCustomersSuccess(success));
  //       },
  //     );
  //   } catch (e) {
  //     emit(FetchLoyaltyCustomersError('An error occurred: $e'));
  //   }
  // }
}
