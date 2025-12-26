import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/get_products_by_category_usecase.dart';

part 'products_state.dart';

class ProductCubit extends Cubit<ProductsState> {
  final FetchProductsUseCase fetchProductsUseCase;
  final ProductLocalRepository _productLocalRepository;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  ProductCubit({
    required this.fetchProductsUseCase,
    required ProductLocalRepository productLocalRepository,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _productLocalRepository = productLocalRepository,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(ProductsInitial());

  // --------------------- API Fetch ---------------------
  Future<void> fetchProducts() async {
    emit(ProductLoading());

    final response = await fetchProductsUseCase();

    response.fold((failure) => emit(ProductFailure(failure.message)), (
      productResponse,
    ) async {
      final productsList = productResponse.productDetails ?? [];

      // ✅ Save to local DB
      await _productLocalRepository.saveProducts(productsList);

      // ✅ Emit loaded state
      emit(ProductSuccess(productResponse));
    });
  }

  // --------------------- Fetch by Category (LOCAL DB) ---------------------
  Future<void> loadProductsByCategory(int categoryId) async {
    emit(ProductsByCategoryLoading());

    try {
      final products = await _getProductsByCategoryUseCase(categoryId);

      if (products.isEmpty) {
        emit(ProductsByCategoryEmpty());
      } else {
        emit(ProductsByCategoryLoaded(products: products));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  // --------------------- Fetch All Products from Local DB ---------------------
  Future<void> loadProductsFromLocal() async {
    emit(ProductLoadingFromLocal());

    try {
      final products = await _productLocalRepository.getProducts();

      if (products.isEmpty) {
        emit(ProductsEmptyFromLocal());
      } else {
        emit(ProductLoadedFromLocal(products));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}
