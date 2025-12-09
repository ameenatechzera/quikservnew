import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/products/data/models/fetch_product_model.dart';
import 'package:quikservnew/features/products/domain/repositories/product_repository.dart';

class FetchProductsUseCase
    implements UseCaseWithoutParams<FetchProductResponseModel> {
  final ProductsRepository _productsRepository;

  FetchProductsUseCase(this._productsRepository);

  @override
  ResultFuture<FetchProductResponseModel> call() async {
    return _productsRepository.fetchProducts();
  }
}
