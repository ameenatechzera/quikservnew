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
