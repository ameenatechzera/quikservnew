import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';
import 'package:quikservnew/features/sale/domain/usecases/save_sale_toserver_usecase.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/usecases/salesDetailsByMasterIdUseCase.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  final SaveSaleUseCase _saveSaleUseCase;
  final SalesDetailsByMasterIdUseCase _salesDetailsByMasterIdUseCase;
  //final SalesRepository _salesRepository;
  //int _selectedSaleTab = 0;
  bool _isSearchBarVisible = false;
  bool _isMenuMode = false;
  String _searchQuery = ''; // ✅ ADD category state variables
  int _selectedCategoryId = 0;
  String _selectedCategoryName = 'All';
  double _editedPrice = 0;
  bool _isPriceEditing = false;

  double get editedPrice => _editedPrice;
  bool get isPriceEditing => _isPriceEditing;
  SaleCubit({
    required SaveSaleUseCase saveSaleUseCase,
    required SalesRepository salesRepository,
    required SalesDetailsByMasterIdUseCase salesDetailsByMasterIdUseCase,
  }) : _saveSaleUseCase = saveSaleUseCase,
       _salesDetailsByMasterIdUseCase = salesDetailsByMasterIdUseCase,
       // _salesRepository = salesRepository,
       super(SaleInitial());

  // void selectSaleTab(int index) {
  //   _selectedSaleTab = index;
  //   emit(SaleTabChanged(_selectedSaleTab));
  // }

  // int get selectedSaleTab => _selectedSaleTab; // ✅ ADD getter

  // ✅ NEW: Search bar methods
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

  // ✅ Getter for search bar visibility
  bool get isSearchBarVisible => _isSearchBarVisible;
  // ✅ NEW: Menu mode methods
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

  // ✅ Getter for menu mode
  bool get isMenuMode => _isMenuMode;
  // ✅ NEW: Search query methods
  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    emit(SearchQueryState(_searchQuery));
  }

  void clearSearchQuery() {
    _searchQuery = '';
    emit(SearchQueryState(_searchQuery));
  }

  // ✅ Getter for search query
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
}
