import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';

class ProductLocalRepositoryImpl implements ProductLocalRepository {
  final AppDatabase database;

  ProductLocalRepositoryImpl(this.database);

  @override
  Future<void> saveProducts(List<FetchProductDetails> products) async {
    print("📥 Saving ${products.length} products INTO Local DB");
    await database.productDao.clearProducts();
    await database.productDao.insertProducts(products);
  }

  @override
  Future<List<FetchProductDetails>> getProducts() async {
    print("📤 Fetching products FROM Local DB...");
    final data = await database.productDao.getAllProducts();
    print("📦 Local DB returned: ${data.length} products");
    return data;
  }

  @override
  Future<void> clearProducts() async {
    await database.productDao.clearProducts();
  }

  @override
  Future<List<FetchProductDetails>> getProductsByCategory(
    int categoryId,
  ) async {
    return await database.productDao.getProductsByCategory(categoryId);
  }
}
