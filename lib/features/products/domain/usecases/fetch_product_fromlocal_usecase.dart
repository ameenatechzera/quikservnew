import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';

class GetLocalProductsUseCase {
  final ProductLocalRepository repository;

  GetLocalProductsUseCase(this.repository);

  Future<List<FetchProductDetails>> call() async {
    return repository.getProducts();
  }
}
