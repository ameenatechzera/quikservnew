import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/parameters/save_product_parameter.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';
import 'package:quikservnew/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/edit_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:quikservnew/features/products/domain/usecases/getproducts_bygroup.dart';
import 'package:quikservnew/features/products/domain/usecases/save_product_usecase.dart';

part 'products_state.dart';

class ProductCubit extends Cubit<ProductsState> {
  final FetchProductsUseCase fetchProductsUseCase;
  final ProductLocalRepository _productLocalRepository;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final SaveProductUseCase _saveProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final EditProductUseCase _editProductUseCase;
  final GetProductsByGroupUseCase _getProductsByGroupUseCase;

  ProductCubit({
    required this.fetchProductsUseCase,
    required ProductLocalRepository productLocalRepository,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required SaveProductUseCase saveProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required EditProductUseCase editProductUseCase,
    required GetProductsByGroupUseCase getProductsByGroupUseCase,
  }) : _productLocalRepository = productLocalRepository,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _saveProductUseCase = saveProductUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       _editProductUseCase = editProductUseCase,
       _getProductsByGroupUseCase = getProductsByGroupUseCase,

       super(ProductsInitial());

  // --------------------- API Fetch ---------------------
  // Future<void> fetchProducts() async {
  //   emit(ProductLoading());

  //   final response = await fetchProductsUseCase();

  //   response.fold((failure) => emit(ProductFailure(failure.message)), (
  //     productResponse,
  //   ) async {
  //     final productsList = productResponse.productDetails ?? [];
  //     print("📤 Saving ${productsList.length} products to local DB");
  //     for (var p in productsList) {
  //       print("Product: ${p.productName}, Code: ${p.productCode}");
  //     }
  //     if (productsList.isEmpty) {
  //       print("⚠️ No products returned from API for this branch/company!");
  //     }

  //     // ✅ Save to local DB
  //     await _productLocalRepository.saveProducts(productsList);

  //     // ✅ Emit loaded state
  //     emit(ProductSuccess(productResponse));
  //   });
  // }
  Future<void> fetchProducts() async {
    print("🔥 fetchProducts() CALLED");
    emit(ProductLoading());

    final response = await fetchProductsUseCase();

    print("🟡 fetchProductsUseCase returned: $response");

    response.fold(
      (failure) {
        print("❌ fetchProducts FAILURE: ${failure.message}");
        emit(ProductFailure(failure.message));
      },
      (productResponse) async {
        print("✅ fetchProducts SUCCESS: got response");

        final productsList = productResponse.productDetails ?? [];
        print("🧪 productsList length = ${productsList.length}");

        try {
          print("🧪 About to save ${productsList.length} products...");

          final missingCode = productsList
              .where((e) => (e.productCode ?? '').isEmpty)
              .length;
          print("🧪 Missing productCode count: $missingCode");

          final bigImgs = productsList
              .where((e) => (e.productImageByte?.length ?? 0) > 200000)
              .length;
          print("🧪 Big images (>200k chars) count: $bigImgs");

          await _productLocalRepository.saveProducts(productsList);

          print("✅ saveProducts completed without throwing");
        } catch (e, st) {
          print("❌ saveProducts FAILED: $e");
          print(st);
        }

        emit(ProductSuccess(productResponse));
      },
    );
  }

  Future<void> clearProducts() async {
    print("🔥 fetchProducts() CALLED");

    await _productLocalRepository.clearProducts();


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
  } // --------------------- SAVE PRODUCT ---------------------

  Future<void> saveProduct(ProductSaveRequest request) async {
    emit(SaveProductLoading());

    final response = await _saveProductUseCase(request);

    response.fold(
      (failure) {
        emit(SaveProductFailure(failure.message));
      },
      (_) async {
        emit(SaveProductSuccess());

        // OPTIONAL: refresh product list after save
        await fetchProducts();
      },
    );
  }

  // 🔹 Delete Product
  Future<void> deleteProduct(int productId) async {
    emit(ProductDeleteLoading());

    final response = await _deleteProductUseCase(productId);

    response.fold(
      (failure) => emit(ProductDeleteError(error: failure.message)),
      (response) => emit(ProductDeleted(response: response)),
    );

    await fetchProducts(); // refresh after deletion
  }

  Future<void> updateProduct(int productId, ProductSaveRequest request) async {
    emit(UpdateProductLoading());

    final response = await _editProductUseCase(productId, request);

    response.fold(
      (failure) {
        emit(UpdateProductFailure(failure.message));
      },
      (response) async {
        emit(UpdateProductSuccess(response: response));

        // refresh product list after update
        await fetchProducts();
      },
    );
  }

  Future<void> loadProductsByGroup(int groupId) async {
    emit(ProductsByGroupLoading());

    try {
      final products = await _getProductsByGroupUseCase(groupId);

      if (products.isEmpty) {
        emit(ProductsByGroupEmpty());
      } else {
        emit(ProductsByGroupLoaded(products: products));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}
