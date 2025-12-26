import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

abstract class ProductLocalRepository {
  Future<void> saveProducts(List<FetchProductDetails> products);
  Future<List<FetchProductDetails>> getProducts();
  Future<void> clearProducts();
  Future<List<FetchProductDetails>> getProductsByCategory(int categoryId);
}
