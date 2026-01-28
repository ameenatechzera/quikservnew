part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductSuccess extends ProductsState {
  final FetchProductResponseModel products;

  const ProductSuccess(this.products);
}

class ProductFailure extends ProductsState {
  final String error;

  const ProductFailure(this.error);
}

// ⭐ Category-wise Product States
class ProductsByCategoryLoading extends ProductsState {}

class ProductsByCategoryEmpty extends ProductsState {}

class ProductsByCategoryLoaded extends ProductsState {
  final List<FetchProductDetails> products;
  ProductsByCategoryLoaded({required this.products});
}

class ProductLoadingFromLocal extends ProductsState {}

class ProductsEmptyFromLocal extends ProductsState {}

class ProductLoadedFromLocal extends ProductsState {
  final List<FetchProductDetails> products;

  ProductLoadedFromLocal(this.products);
}

class SaveProductLoading extends ProductsState {}

class SaveProductSuccess extends ProductsState {}

class SaveProductFailure extends ProductsState {
  final String message;

  const SaveProductFailure(this.message);
}
/* ================= DELETE PRODUCT ================= */

class ProductDeleteLoading extends ProductsState {}

class ProductDeleted extends ProductsState {
  final MasterResponseModel response;

  const ProductDeleted({required this.response});
}

class ProductDeleteError extends ProductsState {
  final String error;

  const ProductDeleteError({required this.error});
}

class UpdateProductLoading extends ProductsState {}

class UpdateProductSuccess extends ProductsState {
  final MasterResponseModel response;
  const UpdateProductSuccess({required this.response});
}

class UpdateProductFailure extends ProductsState {
  final String message;
  const UpdateProductFailure(this.message);
}

class ProductsByGroupLoading extends ProductsState {}

class ProductsByGroupLoaded extends ProductsState {
  final List<FetchProductDetails> products;
  const ProductsByGroupLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductsByGroupEmpty extends ProductsState {}
