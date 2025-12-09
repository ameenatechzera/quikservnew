import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/usecases/fetch_product_usecase.dart';

part 'products_state.dart';

class ProductCubit extends Cubit<ProductsState> {
  final FetchProductsUseCase fetchProductsUseCase;

  ProductCubit({required this.fetchProductsUseCase}) : super(ProductsInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final result = await fetchProductsUseCase();
    result.fold(
      (failure) => emit(ProductFailure(failure.toString())),
      (data) => emit(ProductSuccess(data)),
    );
  }
}
