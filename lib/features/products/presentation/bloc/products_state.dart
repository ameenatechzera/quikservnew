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
