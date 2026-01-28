import 'package:floor/floor.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM tbl_products')
  Future<List<FetchProductDetails>> getAllProducts();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProducts(List<FetchProductDetails> products);

  @Query('DELETE FROM tbl_products')
  Future<void> clearProducts();

  @Query('SELECT * FROM tbl_products WHERE categoryId = :categoryId')
  Future<List<FetchProductDetails>> getProductsByCategory(int categoryId);
  // 🔹 By Group
  @Query('SELECT * FROM tbl_products WHERE groupId = :groupId')
  Future<List<FetchProductDetails>> getProductsByGroup(int groupId);
}
