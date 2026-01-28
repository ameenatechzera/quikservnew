import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';

class GetProductsByGroupUseCase {
  final ProductLocalRepository repository;

  GetProductsByGroupUseCase(this.repository);

  Future<List<FetchProductDetails>> call(int groupId) {
    return repository.getProductsByGroup(groupId);
  }
}
