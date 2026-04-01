import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/domain/repositories/product_local_repository.dart';

class ProductLocalRepositoryImpl implements ProductLocalRepository {
  final AppDatabase database;

  ProductLocalRepositoryImpl(this.database);

  @override
  Future<void> saveProducts(List<FetchProductDetails> products) async {
    await database.productDao.clearProducts();
    await database.productDao.insertProducts(products);
  }

  @override
  Future<List<FetchProductDetails>> getProducts() async {
    final data = await database.productDao.getAllProducts();
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

  @override
  Future<List<FetchProductDetails>> getProductsByGroup(int groupId) async {
    return await database.productDao.getProductsByGroup(groupId);
  }
}
