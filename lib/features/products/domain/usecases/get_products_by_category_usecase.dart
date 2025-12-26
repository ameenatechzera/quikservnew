import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductLocalRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<FetchProductDetails>> call(int categoryId) async {
    return repository.getProductsByCategory(categoryId);
  }
}
